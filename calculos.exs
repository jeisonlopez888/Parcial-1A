# Integrantes: JEISON LOPEZ, LAURA SANCHEZ
# Universidad del Quindío - Programación III - Parcial 1

defmodule Calculos do
  @moduledoc """
  Módulo de reglas de negocio, tarifas, bonificaciones y generación de reportes.
  """

  @tarifa_km 2500
  @meta_diaria 500.0
  @km_bonificacion 80.0
  @bonificacion_diaria 15000
  @alquiler_bicicleta 10000

  def tarifa_km, do: @tarifa_km
  def meta_diaria, do: @meta_diaria

  @doc """
  Calcula el valor ajustado de un servicio según la puntualidad.
  """
  def valor_servicio(%{kilometros: km, retraso: r}) do
    base = km * @tarifa_km

    ajuste =
      cond do
        r <= 0 -> 0.08      # +8% bonificación
        r <= 10 -> 0.00     # Sin ajuste
        r <= 30 -> -0.10    # -10% descuento
        true -> -0.25       # -25% descuento
      end

    base * (1 + ajuste)
  end

  @doc """
  Calcula la liquidación de todos los repartidores.
  """
  def calcular_liquidacion(repartidores, servicios_validos) do
    servs_por_rep = Enum.group_by(servicios_validos, & &1.repartidor)

    Enum.map(repartidores, fn rep ->
      servs = Map.get(servs_por_rep, rep.codigo, [])
      servs_por_dia = Enum.group_by(servs, & &1.dia)

      km_totales = Enum.sum_by(servs, & &1.kilometros)
      val_servicios = Enum.sum_by(servs, &valor_servicio/1)

      dias_bono = Enum.count(servs_por_dia, fn {_dia, lista} ->
        Enum.sum_by(lista, & &1.kilometros) >= @km_bonificacion
      end)
      tot_bono = dias_bono * @bonificacion_diaria

      dias_trabajados = map_size(servs_por_dia)
      tot_alquiler = if rep.bicicleta, do: dias_trabajados * @alquiler_bicicleta, else: 0

      neto = val_servicios + tot_bono - tot_alquiler

      %{
        codigo: rep.codigo,
        nombre: rep.nombre,
        bicicleta: rep.bicicleta,
        kilometros: km_totales,
        servicios_count: length(servs),
        valor_servicios: val_servicios,
        bonificaciones: tot_bono,
        alquiler: tot_alquiler,
        neto: neto,
        servicios_por_dia: servs_por_dia
      }
    end)
  end

  @doc """
  R2. Kilómetros recorridos por zona y densidad (km / area).
  """
  def reporte_r2_densidad(zonas, servicios_validos) do
    servs_por_zona = Enum.group_by(servicios_validos, & &1.zona)

    zonas_calculadas = Enum.map(zonas, fn z ->
      servs = Map.get(servs_por_zona, z.id, [])
      km = Enum.sum_by(servs, & &1.kilometros)
      densidad = if z.area > 0, do: km / z.area, else: 0.0

      %{id: z.id, nombre: z.nombre, area: z.area, kilometros: km, densidad: densidad}
    end)

    Util2.ordenar(zonas_calculadas, :desc, & &1.densidad)
  end

  @doc """
  R3. Kilómetros recorridos por día vs meta de 500 km.
  """
  def reporte_r3_meta_diaria(servicios_validos) do
    servs_por_dia = Enum.group_by(servicios_validos, & &1.dia)

    dias_reporte = Enum.map(1..6, fn d ->
      servs = Map.get(servs_por_dia, d, [])
      km = Enum.sum_by(servs, & &1.kilometros)
      alcanzo = km >= @meta_diaria
      %{dia: d, kilometros: km, alcanzo_meta: alcanzo}
    end)

    todos = Enum.all?(dias_reporte, & &1.alcanzo_meta)
    al_menos_uno = Enum.any?(dias_reporte, & &1.alcanzo_meta)

    {dias_reporte, todos, al_menos_uno}
  end

  @doc """
  R5. Líderes diarios en kilómetros recorridos.
  """
  def reporte_r5_lideres(repartidores, servicios_validos) do
    servs_por_dia = Enum.group_by(servicios_validos, & &1.dia)

    lideres_por_dia = Enum.map(1..6, fn d ->
      servs_dia = Map.get(servs_por_dia, d, [])
      servs_rep = Enum.group_by(servs_dia, & &1.repartidor)

      km_reps = Enum.map(repartidores, fn r ->
        s_list = Map.get(servs_rep, r.codigo, [])
        km = Enum.sum_by(s_list, & &1.kilometros)
        %{codigo: r.codigo, nombre: r.nombre, kilometros: km}
      end)

      max_km = Enum.map(km_reps, & &1.kilometros) |> Enum.max(fn -> 0.0 end)
      lideres = Enum.filter(km_reps, &(&1.kilometros == max_km and max_km > 0))

      %{dia: d, max_km: max_km, lideres: lideres}
    end)

    # Contar primeros lugares por repartidor
    frecuencias =
      lideres_por_dia
      |> Enum.flat_map(& &1.lideres)
      |> Enum.frequencies_by(& &1.nombre)

    lider_global =
      if map_size(frecuencias) > 0 do
        Enum.max_by(frecuencias, fn {_nombre, cant} -> cant end)
      else
        {"Ninguno", 0}
      end

    {lideres_por_dia, lider_global}
  end

  @doc """
  R6. Repartidor con mejor puntualidad ponderada (mínimo 3 servicios válidos).
  Fórmula: sum(retraso * km) / sum(km)
  """
  def reporte_r6_puntualidad_ponderada(repartidores, servicios_validos) do
    servs_por_rep = Enum.group_by(servicios_validos, & &1.repartidor)

    candidatos =
      repartidores
      |> Enum.map(fn rep ->
        servs = Map.get(servs_por_rep, rep.codigo, [])
        count = length(servs)

        if count >= 3 do
          sum_retraso_km = Enum.sum_by(servs, fn s -> s.retraso * s.kilometros end)
          sum_km = Enum.sum_by(servs, & &1.kilometros)
          ponderada = if sum_km > 0, do: sum_retraso_km / sum_km, else: 0.0

          %{codigo: rep.codigo, nombre: rep.nombre, servicios_count: count, ponderada: ponderada}
        else
          nil
        end
      end)
      |> Enum.reject(&is_nil/1)

    sorted = Util2.ordenar(candidatos, :asc, & &1.ponderada)
    mejor = List.first(sorted)

    {sorted, mejor}
  end

  @doc """
  R7. Resumen financiero global. Total pagado y costo promedio por km.
  """
  def reporte_r7_resumen_financiero(liquidaciones, servicios_validos) do
    total_pagado = Enum.sum_by(liquidaciones, & &1.neto)
    total_km = Enum.sum_by(servicios_validos, & &1.kilometros)
    costo_promedio_km = if total_km > 0, do: total_pagado / total_km, else: 0.0

    %{total_pagado: total_pagado, total_km: total_km, costo_promedio_km: costo_promedio_km}
  end

  @doc """
  R8. Repartidores con servicios válidos en las 4 zonas.
  """
  def reporte_r8_cobertura_zonas(repartidores, servicios_validos) do
    servs_por_rep = Enum.group_by(servicios_validos, & &1.repartidor)

    Enum.filter(repartidores, fn rep ->
      servs = Map.get(servs_por_rep, rep.codigo, [])
      zonas_visitadas = servs |> Enum.map(& &1.zona) |> Enum.uniq() |> length()
      zonas_visitadas == 4
    end)
  end

  @doc """
  Función ranking/2 configurada mediante Keyword Lists.
  Opciones permitidas: [orden: :asc | :desc, limite: entero]
  """
  def ranking(coleccion, opciones \\ []) do
    sentido = Keyword.get(opciones, :orden, :desc)
    limite = Keyword.get(opciones, :limite, length(coleccion))
    campo_fn = Keyword.get(opciones, :campo, & &1.neto)

    coleccion
    |> Util2.ordenar(sentido, campo_fn)
    |> Enum.take(limite)
  end

  @doc """
  Investigación Map.merge/3: combina kilómetros diarios propios con empresa aliada.
  """
  def combinar_con_empresa_aliada(km_diarios_r3) do
    empresa_aliada = %{1 => 580.5, 2 => 430.0, 3 => 510.0, 5 => 625.0, 7 => 180.0}

    mapa_nuestro =
      km_diarios_r3
      |> Enum.map(fn item -> {item.dia, item.kilometros} end)
      |> Enum.into(%{})

    Map.merge(mapa_nuestro, empresa_aliada, fn _dia, km_nuestro, km_aliado ->
      km_nuestro + km_aliado
    end)
  end
end


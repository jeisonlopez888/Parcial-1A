# Integrantes: Estudiante 1, Estudiante 2, Estudiante 3
# Universidad del Quindío - Programación III - Parcial 1

defmodule Reportes do
  @moduledoc """
  Módulo encargado del formato y presentación de los reportes R1 a R8.
  """

  def generar_r1(servicios_rechazados) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R1. SERVICIOS RECHAZADOS Y MOTIVOS DE ERROR   ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    if Enum.empty?(servicios_rechazados) do
      Util2.mostrar("No se registraron servicios rechazados.", :mensaje)
    else
      lineas =
        Util2.convertir_coleccion_mensaje(servicios_rechazados, fn {s, motivo} ->
          " Repartidor: #{s.repartidor} | Zona: #{s.zona} | Día: #{s.dia} | Km: #{s.kilometros} | Retraso: #{s.retraso} -> MOTIVO: #{motivo}\n"
        end)

      Enum.each(lineas, &Util2.mostrar(&1, :mensaje))

      frecuencias = Enum.frequencies_by(servicios_rechazados, fn {_s, motivo} -> motivo end)
      Util2.mostrar("\n--- Resumen de Rechazos por Motivo ---", :mensaje)

      Enum.each(frecuencias, fn {motivo, cant} ->
        Util2.mostrar(" - #{motivo}: #{cant} ocurrencia(s)", :mensaje)
      end)
    end
  end

  def generar_r2(zonas, servicios_validos) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R2. DENSIDAD DE RECORRIDO POR ZONA (Km / Area) ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    reporte = Calculos.reporte_r2_densidad(zonas, servicios_validos)

    lineas =
      Util2.convertir_coleccion_mensaje(reporte, fn z ->
        dens_str = :erlang.float_to_binary(z.densidad, decimals: 2)
        " [#{z.id}] #{z.nombre} | Área: #{z.area} km² | Km Recorridos: #{z.kilometros} km | Densidad: #{dens_str} km/km²\n"
      end)

    Enum.each(lineas, &Util2.mostrar(&1, :mensaje))
  end

  def generar_r3(servicios_validos) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R3. CUMPLIMIENTO DE METAS DIARIAS (500 km/día) ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    {dias_reporte, todos, al_menos_uno} = Calculos.reporte_r3_meta_diaria(servicios_validos)

    lineas =
      Util2.convertir_coleccion_mensaje(dias_reporte, fn d ->
        estado = if d.alcanzo_meta, do: "ALCANZADA (>= 500 km)", else: "NO ALCANZADA"
        " Día #{d.dia}: #{d.kilometros} km recorridos -> Estado: #{estado}\n"
      end)

    Enum.each(lineas, &Util2.mostrar(&1, :mensaje))

    Util2.mostrar("--- Resumen Global de Metas ---", :mensaje)
    Util2.mostrar(" ¿Se alcanzó la meta TODOS los días? #{if todos, do: "SÍ", else: "NO"}", :mensaje)
    Util2.mostrar(" ¿Se alcanzó la meta AL MENOS UN día? #{if al_menos_uno, do: "SÍ", else: "NO"}", :mensaje)
  end

  def generar_r4(liquidaciones) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R4. LIQUIDACIÓN SEMANAL DE REPARTIDORES        ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    ordenadas = Util2.ordenar(liquidaciones, :desc, & &1.neto)

    lineas =
      ordenadas
      |> Enum.with_index(1)
      |> Enum.map(fn {l, idx} ->
        val_str = :erlang.float_to_binary(l.valor_servicios, decimals: 2)
        neto_str = :erlang.float_to_binary(l.neto, decimals: 2)
        bici_str = if l.bicicleta, do: "SÍ (-$#{l.alquiler})", else: "NO ($0)"

        " #{idx}. [#{l.codigo}] #{l.nombre} | Km: #{l.kilometros} | Serv: #{l.servicios_count} | ValServ: $#{val_str} | Bono: $#{l.bonificaciones} | Bici: #{bici_str} | NETO: $#{neto_str}\n"
      end)
      |> Util2.convertir_coleccion_mensaje(& &1)

    Enum.each(lineas, &Util2.mostrar(&1, :mensaje))
  end

  def generar_r5(repartidores, servicios_validos) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R5. LÍDERES DIARIOS EN KILÓMETROS RECORRIDOS   ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    {lideres_dia, {nombre_top, cant_top}} = Calculos.reporte_r5_lideres(repartidores, servicios_validos)

    Enum.each(lideres_dia, fn item ->
      nombres = Enum.map_join(item.lideres, ", ", & &1.nombre)
      Util2.mostrar(" Día #{item.dia}: #{nombres} con #{item.max_km} km", :mensaje)
    end)

    Util2.mostrar("\n Repartidor con más días en 1er lugar: #{nombre_top} (#{cant_top} días)", :mensaje)
  end

  def generar_r6(repartidores, servicios_validos) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R6. MEJOR PUNTUALIDAD PONDERADA (>=3 SERVICIOS)", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    {ranking, mejor} = Calculos.reporte_r6_puntualidad_ponderada(repartidores, servicios_validos)

    lineas =
      ranking
      |> Enum.with_index(1)
      |> Enum.map(fn {item, idx} ->
        pond_str = :erlang.float_to_binary(item.ponderada, decimals: 2)
        " #{idx}. [#{item.codigo}] #{item.nombre} | Servicios: #{item.servicios_count} | Retraso Ponderado: #{pond_str} min\n"
      end)
      |> Util2.convertir_coleccion_mensaje(& &1)

    Enum.each(lineas, &Util2.mostrar(&1, :mensaje))

    if mejor do
      pond_m = :erlang.float_to_binary(mejor.ponderada, decimals: 2)
      Util2.mostrar(" GANADOR R6: #{mejor.nombre} con puntualidad ponderada de #{pond_m} min", :mensaje)
    end
  end

  def generar_r7(liquidaciones, servicios_validos) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R7. RESUMEN FINANCIERO GLOBAL DE LA EMPRESA    ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    res = Calculos.reporte_r7_resumen_financiero(liquidaciones, servicios_validos)
    tot_str = :erlang.float_to_binary(res.total_pagado, decimals: 2)
    prom_str = :erlang.float_to_binary(res.costo_promedio_km, decimals: 2)

    Util2.mostrar(" Total pagado a repartidores en la semana: $#{tot_str}", :mensaje)
    Util2.mostrar(" Total de kilómetros válidos recorridos: #{res.total_km} km", :mensaje)
    Util2.mostrar(" Costo promedio pagado por kilómetro: $#{prom_str} / km", :mensaje)
  end

  def generar_r8(repartidores, servicios_validos) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   R8. REPARTIDORES CON COBERTURA EN LAS 4 ZONAS  ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)

    completos = Calculos.reporte_r8_cobertura_zonas(repartidores, servicios_validos)

    if Enum.empty?(completos) do
      Util2.mostrar(" Ningún repartidor realizó servicios válidos en las 4 zonas.", :mensaje)
    else
      lineas = Util2.convertir_coleccion_mensaje(completos, fn r -> " - [#{r.codigo}] #{r.nombre}\n" end)
      Enum.each(lineas, &Util2.mostrar(&1, :mensaje))
    end
  end

  def generar_comprobante(codigo_rep, liquidaciones) do
    case Enum.find(liquidaciones, &(&1.codigo == String.upcase(codigo_rep))) do
      nil ->
        Util2.mostrar("\nError: El código '#{codigo_rep}' no corresponde a ningún repartidor registrado.\n", :error)

      l ->
        Util2.mostrar("\n==================================================", :mensaje)
        Util2.mostrar("     COMPROBANTE INDIVIDUAL DE LIQUIDACIÓN         ", :mensaje)
        Util2.mostrar("==================================================", :mensaje)
        Util2.mostrar(" Código: #{l.codigo} | Nombre: #{l.nombre}", :mensaje)
        Util2.mostrar(" Bicicleta Eléctrica: #{if l.bicicleta, do: "SÍ", else: "NO"}", :mensaje)
        Util2.mostrar("--------------------------------------------------", :mensaje)
        Util2.mostrar(" DETALLE DÍA A DÍA (Días trabajados):", :mensaje)

        dias_ordenados = Util2.ordenar(Map.keys(l.servicios_por_dia))

        Enum.each(dias_ordenados, fn d ->
          servs_dia = Map.get(l.servicios_por_dia, d, [])
          km_dia = Enum.sum_by(servs_dia, & &1.kilometros)
          val_dia = Enum.sum_by(servs_dia, &Calculos.valor_servicio/1)
          bono_dia = if km_dia >= 80.0, do: 15000, else: 0

          val_str = :erlang.float_to_binary(val_dia, decimals: 2)
          Util2.mostrar("  * Día #{d}: #{km_dia} km | Val. Servicios: $#{val_str} | Bono: $#{bono_dia}", :mensaje)
        end)

        val_tot_str = :erlang.float_to_binary(l.valor_servicios, decimals: 2)
        neto_tot_str = :erlang.float_to_binary(l.neto, decimals: 2)

        Util2.mostrar("--------------------------------------------------", :mensaje)
        Util2.mostrar(" Suma Valor Servicios: $#{val_tot_str}", :mensaje)
        Util2.mostrar(" Suma Bonificaciones: $#{l.bonificaciones}", :mensaje)
        Util2.mostrar(" Descuento Alquiler Bici: -$#{l.alquiler}", :mensaje)
        Util2.mostrar(" TOTAL NETO A PAGAR: $#{neto_tot_str}", :mensaje)
        Util2.mostrar("==================================================\n", :mensaje)
    end
  end
end

# Integrantes: JEISON LOPEZ, LAURA SANCHEZ
# Universidad del Quindío - Programación III - Parcial 1

Code.require_file("util2.exs")
Code.require_file("datos.exs")
Code.require_file("validacion.exs")
Code.require_file("calculos.exs")
Code.require_file("reportes.exs")

defmodule Main do
  @moduledoc """
  Módulo principal interactivo que presenta un menú de opciones desplegable por consola.
  Permite ingresar servicios paso a paso, consultar reportes, comprobantes e investigación.
  """

  def main do
    repartidores = Datos.repartidores()
    zonas = Datos.zonas()
    servicios_iniciales = Datos.servicios()

    menu_principal(servicios_iniciales, repartidores, zonas)
  end

  defp menu_principal(servicios_actuales, repartidores, zonas) do
    Util2.mostrar("\n==================================================", :mensaje)
    Util2.mostrar("   EMPRESA DE MENSAJERÍA - MENÚ INTERACTIVO      ", :mensaje)
    Util2.mostrar("==================================================", :mensaje)
    Util2.mostrar(" 1. Ingresar nuevo servicio (paso a paso)", :mensaje)
    Util2.mostrar(" 2. Generar todos los reportes de liquidación (R1 a R8)", :mensaje)
    Util2.mostrar(" 3. Consultar comprobante individual de repartidor", :mensaje)
    Util2.mostrar(" 4. Ver análisis teóricos (Map.merge/3 y ranking/2)", :mensaje)
    Util2.mostrar(" 5. Salir del sistema", :mensaje)
    Util2.mostrar("--------------------------------------------------", :mensaje)

    opcion = Util2.ingresar("Seleccione una opción (1-5): ", :entero)

    case opcion do
      1 ->
        nuevo_servicio = Validacion.pedir_servicio_paso_a_paso()

        case Validacion.validar_servicio(nuevo_servicio, repartidores, zonas) do
          {:ok, _} ->
            Util2.mostrar("-> ¡Servicio VÁLIDO ingresado e incorporado exitosamente!", :mensaje)
            menu_principal([nuevo_servicio | servicios_actuales], repartidores, zonas)

          {:error, motivo} ->
            Util2.mostrar("-> ATENCIÓN: El servicio es INVÁLIDO por motivo: #{motivo}", :error)
            Util2.mostrar("   Aún así se registrará para el reporte R1 de rechazados.", :mensaje)
            menu_principal([nuevo_servicio | servicios_actuales], repartidores, zonas)
        end

      2 ->
        # Clasificación de servicios válidos vs rechazados
        {validos, rechazados} = clasificar_servicios(servicios_actuales, repartidores, zonas)
        liquidaciones = Calculos.calcular_liquidacion(repartidores, validos)

        {tiempo_micro, _} =
          :timer.tc(fn ->
            Reportes.generar_r1(rechazados)
            Reportes.generar_r2(zonas, validos)
            Reportes.generar_r3(validos)
            Reportes.generar_r4(liquidaciones)
            Reportes.generar_r5(repartidores, validos)
            Reportes.generar_r6(repartidores, validos)
            Reportes.generar_r7(liquidaciones, validos)
            Reportes.generar_r8(repartidores, validos)
          end)

        tiempo_ms = tiempo_micro / 1000.0
        Util2.mostrar("\n[Medición :timer.tc] Tiempo total de generación de reportes: #{tiempo_ms} ms", :mensaje)

        menu_principal(servicios_actuales, repartidores, zonas)

      3 ->
        {validos, _} = clasificar_servicios(servicios_actuales, repartidores, zonas)
        liquidaciones = Calculos.calcular_liquidacion(repartidores, validos)

        cod = Util2.ingresar("\nIngrese el código del repartidor a consultar (ej: M01): ", :texto)
        if cod != "", do: Reportes.generar_comprobante(cod, liquidaciones)

        menu_principal(servicios_actuales, repartidores, zonas)

      4 ->
        {validos, _} = clasificar_servicios(servicios_actuales, repartidores, zonas)

        Util2.mostrar("\n--- INVESTIGACIÓN: COMBINACIÓN DE EMPRESAS (Map.merge/3) ---", :mensaje)
        {dias_r3, _, _} = Calculos.reporte_r3_meta_diaria(validos)
        mapa_combinado = Calculos.combinar_con_empresa_aliada(dias_r3)
        IO.inspect(mapa_combinado, label: "Kilómetros combinados (Nuestra + Empresa Aliada)")

        Util2.mostrar("\n--- DEMOSTRACIÓN: FUNCIÓN ranking/2 CON KEYWORD LISTS ---", :mensaje)
        liquidaciones = Calculos.calcular_liquidacion(repartidores, validos)
        top3_neto = Calculos.ranking(liquidaciones, orden: :desc, limite: 3)
        IO.inspect(Enum.map(top3_neto, &%{codigo: &1.codigo, neto: &1.neto}), label: "Top 3 Mayor Neto")

        menu_principal(servicios_actuales, repartidores, zonas)

      5 ->
        Util2.mostrar("\n¡Gracias por utilizar el sistema de liquidación de mensajería! Hasta luego.", :mensaje)

      _ ->
        Util2.mostrar("\nOpción no válida. Intente nuevamente.", :error)
        menu_principal(servicios_actuales, repartidores, zonas)
    end
  end

  defp clasificar_servicios(servicios, repartidores, zonas) do
    Enum.reduce(servicios, {[], []}, fn s, {val, rech} ->
      case Validacion.validar_servicio(s, repartidores, zonas) do
        {:ok, serv_val} -> {[serv_val | val], rech}
        {:error, motivo} -> {val, [{s, motivo} | rech]}
      end
    end)
  end
end

Main.main()

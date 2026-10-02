# Integrantes: Laura Sanchez, Jeison Lopez
# Universidad del Quindío - Programación III - Parcial 1

defmodule Validacion do
  @moduledoc """
  Módulo de validación de servicios y formatos de entrada.
  Aplica el orden estricto de reglas mediante la estructura `with`.
  """

  @doc """
  Valida un servicio en el orden estricto solicitado:
  1. Repartidor existe -> :repartidor_desconocido
  2. Zona existe -> :zona_desconocida
  3. Día es entero 1..6 -> :dia_invalido
  4. Kilómetros en rango (0 < km <= 45) -> :kilometros_fuera_de_rango
  5. Retraso en rango (-30 <= r <= 180) -> :retraso_invalido
  """
  def validar_servicio(servicio, repartidores, zonas) do
    with {:ok, s} <- validar_repartidor(servicio, repartidores),
         {:ok, s} <- validar_zona(s, zonas),
         {:ok, s} <- validar_dia(s),
         {:ok, s} <- validar_kilometros(s),
         {:ok, s} <- validar_retraso(s) do
      {:ok, s}
    end
  end

  defp validar_repartidor(%{repartidor: cod} = s, repartidores) do
    if Enum.any?(repartidores, &(&1.codigo == cod)) do
      {:ok, s}
    else
      {:error, :repartidor_desconocido}
    end
  end

  defp validar_zona(%{zona: z_id} = s, zonas) do
    if Enum.any?(zonas, &(&1.id == z_id)) do
      {:ok, s}
    else
      {:error, :zona_desconocida}
    end
  end

  defp validar_dia(%{dia: d} = s) when is_integer(d) and d in 1..6, do: {:ok, s}
  defp validar_dia(_s), do: {:error, :dia_invalido}

  defp validar_kilometros(%{kilometros: km} = s) when is_number(km) and km > 0 and km <= 45 do
    {:ok, s}
  end
  defp validar_kilometros(_s), do: {:error, :kilometros_fuera_de_rango}

  defp validar_retraso(%{retraso: r} = s) when is_number(r) and r >= -30 and r <= 180 do
    {:ok, s}
  end
  defp validar_retraso(_s), do: {:error, :retraso_invalido}

  @doc """
  Solicita interactivamente los datos campo por campo usando Util2.
  Evita errores de sintaxis y hace la experiencia mucho más intuitiva.
  """
  def pedir_servicio_paso_a_paso do
    Util2.mostrar("\n--- INGRESO INTERACTIVO DE SERVICIO ---", :mensaje)
    rep = Util2.ingresar("1. Código del repartidor (ej. M01): ", :texto) |> String.upcase()
    zona = Util2.ingresar("2. ID de la zona (ej. Z1): ", :texto) |> String.upcase()
    dia = Util2.ingresar("3. Día de la semana (1 a 6): ", :entero)
    km = Util2.ingresar("4. Kilómetros recorridos (ej. 25.5): ", :real)
    ret = Util2.ingresar("5. Retraso en minutos (ej. -5 para entrega anticipada o 10): ", :real)

    %{repartidor: rep, zona: zona, dia: dia, kilometros: km, retraso: ret}
  end

  @doc """
  Valida el formato del servicio adicional ingresado en una sola línea:
  `repartidor;zona;dia;kilometros;retraso`
  """
  def validar_formato_texto(cadena_texto) do
    partes = String.split(cadena_texto, ";")

    case partes do
      [rep, zona, dia_str, km_str, ret_str] ->
        with {dia, ""} <- Integer.parse(String.trim(dia_str)),
             {km, ""} <- parse_numero(String.trim(km_str)),
             {ret, ""} <- parse_numero(String.trim(ret_str)) do
          {:ok, %{repartidor: String.trim(rep) |> String.upcase(), zona: String.trim(zona) |> String.upcase(), dia: dia, kilometros: km, retraso: ret}}
        else
          _ -> {:error, :formato_invalido}
        end

      _ -> {:error, :formato_invalido}
    end
  end

  defp parse_numero(str) do
    case Float.parse(str) do
      {num, ""} -> {num, ""}
      :error -> Integer.parse(str)
    end
  end
end

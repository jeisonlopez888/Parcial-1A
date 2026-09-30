# Integrantes: JEISON LOPEZ, LAURA SANCHEZ
# Universidad del Quindío - Programación III - Parcial 1

defmodule Validacion do
  @doc "Valida las 5 reglas en orden estricto devolviendo {:ok, servicio} o {:error, motivo}"
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
    if Enum.any?(repartidores, &(&1.codigo == cod)), do: {:ok, s}, else: {:error, :repartidor_desconocido}
  end

  defp validar_zona(%{zona: z_id} = s, zonas) do
    if Enum.any?(zonas, &(&1.id == z_id)), do: {:ok, s}, else: {:error, :zona_desconocida}
  end

  defp validar_dia(%{dia: d} = s) when is_integer(d) and d in 1..6, do: {:ok, s}
  defp validar_dia(_s), do: {:error, :dia_invalido}

  defp validar_kilometros(%{kilometros: km} = s) when is_number(km) and km > 0 and km <= 45, do: {:ok, s}
  defp validar_kilometros(_s), do: {:error, :kilometros_fuera_de_rango}

  defp validar_retraso(%{retraso: r} = s) when is_number(r) and r >= -30 and r <= 180, do: {:ok, s}
  defp validar_retraso(_s), do: {:error, :retraso_invalido}

  @doc "Valida el formato del servicio adicional ingresado por teclado"
  def validar_formato_texto(cadena_texto) do
    partes = String.split(cadena_texto, ";")

    case partes do
      [rep, zona, dia_str, km_str, ret_str] ->
        with {dia, ""} <- Integer.parse(dia_str),
             {km, ""} <- Float.parse(km_str),
             {ret, ""} <- Float.parse(ret_str) do
          {:ok, %{repartidor: rep, zona: zona, dia: dia, kilometros: km, retraso: ret}}
        else
          _ -> {:error, :formato_invalido}
        end

      _ -> {:error, :formato_invalido}
    end
  end
end

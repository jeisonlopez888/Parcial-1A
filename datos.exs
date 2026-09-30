# Integrantes: JEISON LOPEZ, LAURA SANCHEZ
# Universidad del Quindío - Programación III - Parcial 1

defmodule Datos do
  @doc "Mínimo 10 repartidores, al menos 4 con bicicleta"
  def repartidores do
    [
      %{codigo: "M01", nombre: "Ana Torres", bicicleta: true},
      %{codigo: "M02", nombre: "David López", bicicleta: false},
      %{codigo: "M03", nombre: "Carlos Ruiz", bicicleta: true},
      %{codigo: "M04", nombre: "Elena Gómez", bicicleta: false},
      %{codigo: "M05", nombre: "Fernando Patiño", bicicleta: true},
      %{codigo: "M06", nombre: "Gloria Marín", bicicleta: false},
      %{codigo: "M07", nombre: "Hugo Morales", bicicleta: true},
      %{codigo: "M08", nombre: "Irene Salazar", bicicleta: false},
      %{codigo: "M09", nombre: "Jorge Vargas", bicicleta: false},
      %{codigo: "M10", nombre: "Luisa Fernández", bicicleta: false}
    ]
  end

  @doc "4 zonas de la ciudad"
  def zonas do
    [
      %{id: "Z1", nombre: "Centro", area: 6.5},
      %{id: "Z2", nombre: "Norte", area: 10.2},
      %{id: "Z3", nombre: "Sur", area: 8.0},
      %{id: "Z4", nombre: "Occidente", area: 12.4}
    ]
  end

  @doc "Mínimo 80 servicios válidos y al menos 2 inválidos por motivo"
  def servicios do
    [
      %{repartidor: "M01", zona: "Z1", dia: 1, kilometros: 18.0, retraso: -5},
      %{repartidor: "M01", zona: "Z2", dia: 1, kilometros: 25.0, retraso: 12},
      # Servidores inválidos de prueba:
      %{repartidor: "M99", zona: "Z1", dia: 1, kilometros: 10.0, retraso: 0},   # :repartidor_desconocido
      %{repartidor: "M01", zona: "Z9", dia: 1, kilometros: 10.0, retraso: 0},   # :zona_desconocida
      %{repartidor: "M01", zona: "Z1", dia: 8, kilometros: 10.0, retraso: 0},   # :dia_invalido
      %{repartidor: "M01", zona: "Z1", dia: 1, kilometros: 50.0, retraso: 0},   # :kilometros_fuera_de_rango
      %{repartidor: "M01", zona: "Z1", dia: 1, kilometros: 10.0, retraso: 200}  # :retraso_invalido
      # ... completar el listado 
    ]
  end
end

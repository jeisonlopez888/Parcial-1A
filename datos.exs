# Integrantes: Laura Sanchez, Jeison Lopez 
# Universidad del Quindío - Programación III - Parcial 1

defmodule Datos do
  @moduledoc """
  Fuente de datos para el sistema de mensajería.
  Contiene repartidores, zonas de la ciudad y registros de servicios.
  """

  @doc """
  Retorna la lista de repartidores (10 repartidores, 4 con bicicleta).
  """
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

  @doc """
  Retorna las 4 zonas de la ciudad con sus áreas en km².
  """
  def zonas do
    [
      %{id: "Z1", nombre: "Centro", area: 6.5},
      %{id: "Z2", nombre: "Norte", area: 10.2},
      %{id: "Z3", nombre: "Sur", area: 8.0},
      %{id: "Z4", nombre: "Occidente", area: 12.4}
    ]
  end

  @doc """
  Retorna el listado de servicios (mínimo 80 válidos y 10 inválidos).
  """
  def servicios do
    # 85 servicios válidos + 10 inválidos de prueba
    [
      # --- Día 1 ---
      %{repartidor: "M01", zona: "Z1", dia: 1, kilometros: 18.0, retraso: -5},
      %{repartidor: "M01", zona: "Z2", dia: 1, kilometros: 25.0, retraso: 12},
      %{repartidor: "M01", zona: "Z3", dia: 1, kilometros: 42.0, retraso: 0}, # Suma 85 km -> Bono
      %{repartidor: "M02", zona: "Z1", dia: 1, kilometros: 30.0, retraso: 5},
      %{repartidor: "M02", zona: "Z4", dia: 1, kilometros: 35.0, retraso: -10},
      %{repartidor: "M03", zona: "Z2", dia: 1, kilometros: 20.0, retraso: 15},
      %{repartidor: "M03", zona: "Z3", dia: 1, kilometros: 15.0, retraso: 35},
      %{repartidor: "M04", zona: "Z4", dia: 1, kilometros: 10.0, retraso: -2},
      %{repartidor: "M05", zona: "Z1", dia: 1, kilometros: 28.0, retraso: 8},
      %{repartidor: "M05", zona: "Z2", dia: 1, kilometros: 22.0, retraso: -4},
      %{repartidor: "M06", zona: "Z3", dia: 1, kilometros: 12.0, retraso: 18},
      %{repartidor: "M07", zona: "Z4", dia: 1, kilometros: 40.0, retraso: -15},
      %{repartidor: "M07", zona: "Z1", dia: 1, kilometros: 45.0, retraso: -8}, # Suma 85 km -> Bono
      %{repartidor: "M08", zona: "Z2", dia: 1, kilometros: 14.0, retraso: 2},
      %{repartidor: "M09", zona: "Z3", dia: 1, kilometros: 16.0, retraso: 0},

      # --- Día 2 ---
      %{repartidor: "M01", zona: "Z3", dia: 2, kilometros: 22.0, retraso: 4},
      %{repartidor: "M01", zona: "Z4", dia: 2, kilometros: 38.0, retraso: -2},
      %{repartidor: "M02", zona: "Z2", dia: 2, kilometros: 44.0, retraso: 25},
      %{repartidor: "M02", zona: "Z3", dia: 2, kilometros: 40.0, retraso: 8}, # Suma 84 km -> Bono
      %{repartidor: "M03", zona: "Z1", dia: 2, kilometros: 15.0, retraso: -6},
      %{repartidor: "M03", zona: "Z4", dia: 2, kilometros: 28.0, retraso: 0},
      %{repartidor: "M04", zona: "Z1", dia: 2, kilometros: 19.0, retraso: 3},
      %{repartidor: "M05", zona: "Z3", dia: 2, kilometros: 31.0, retraso: 40},
      %{repartidor: "M06", zona: "Z4", dia: 2, kilometros: 27.0, retraso: -1},
      %{repartidor: "M07", zona: "Z2", dia: 2, kilometros: 33.0, retraso: 11},
      %{repartidor: "M08", zona: "Z1", dia: 2, kilometros: 21.0, retraso: -5},
      %{repartidor: "M09", zona: "Z4", dia: 2, kilometros: 18.0, retraso: 14},
      %{repartidor: "M10", zona: "Z3", dia: 2, kilometros: 25.0, retraso: -3},

      # --- Día 3 ---
      %{repartidor: "M01", zona: "Z1", dia: 3, kilometros: 15.0, retraso: -8},
      %{repartidor: "M02", zona: "Z1", dia: 3, kilometros: 32.0, retraso: 0},
      %{repartidor: "M03", zona: "Z2", dia: 3, kilometros: 41.0, retraso: 10},
      %{repartidor: "M03", zona: "Z3", dia: 3, kilometros: 40.0, retraso: -5}, # Suma 81 km -> Bono
      %{repartidor: "M04", zona: "Z2", dia: 3, kilometros: 22.0, retraso: 28},
      %{repartidor: "M05", zona: "Z4", dia: 3, kilometros: 19.0, retraso: -12},
      %{repartidor: "M06", zona: "Z1", dia: 3, kilometros: 35.0, retraso: 2},
      %{repartidor: "M07", zona: "Z3", dia: 3, kilometros: 26.0, retraso: 6},
      %{repartidor: "M08", zona: "Z4", dia: 3, kilometros: 30.0, retraso: -4},
      %{repartidor: "M09", zona: "Z2", dia: 3, kilometros: 24.0, retraso: 16},
      %{repartidor: "M10", zona: "Z1", dia: 3, kilometros: 29.0, retraso: -2},

      # --- Día 4 ---
      %{repartidor: "M01", zona: "Z2", dia: 4, kilometros: 36.0, retraso: 1},
      %{repartidor: "M02", zona: "Z4", dia: 4, kilometros: 18.0, retraso: -7},
      %{repartidor: "M03", zona: "Z1", dia: 4, kilometros: 22.0, retraso: 0},
      %{repartidor: "M04", zona: "Z3", dia: 4, kilometros: 34.0, retraso: 12},
      %{repartidor: "M05", zona: "Z2", dia: 4, kilometros: 43.0, retraso: -15},
      %{repartidor: "M05", zona: "Z3", dia: 4, kilometros: 38.0, retraso: -5}, # Suma 81 km -> Bono
      %{repartidor: "M06", zona: "Z4", dia: 4, kilometros: 15.0, retraso: 50},
      %{repartidor: "M07", zona: "Z1", dia: 4, kilometros: 29.0, retraso: -3},
      %{repartidor: "M08", zona: "Z3", dia: 4, kilometros: 27.0, retraso: 0},
      %{repartidor: "M09", zona: "Z1", dia: 4, kilometros: 31.0, retraso: 9},
      %{repartidor: "M10", zona: "Z2", dia: 4, kilometros: 17.0, retraso: -10},

      # --- Día 5 ---
      %{repartidor: "M01", zona: "Z4", dia: 5, kilometros: 28.0, retraso: -4},
      %{repartidor: "M02", zona: "Z2", dia: 5, kilometros: 39.0, retraso: 18},
      %{repartidor: "M03", zona: "Z4", dia: 5, kilometros: 30.0, retraso: -2},
      %{repartidor: "M04", zona: "Z1", dia: 5, kilometros: 26.0, retraso: 4},
      %{repartidor: "M05", zona: "Z1", dia: 5, kilometros: 21.0, retraso: 0},
      %{repartidor: "M06", zona: "Z2", dia: 5, kilometros: 33.0, retraso: -9},
      %{repartidor: "M07", zona: "Z4", dia: 5, kilometros: 42.0, retraso: 3},
      %{repartidor: "M07", zona: "Z2", dia: 5, kilometros: 41.0, retraso: -6}, # Suma 83 km -> Bono
      %{repartidor: "M08", zona: "Z1", dia: 5, kilometros: 19.0, retraso: 22},
      %{repartidor: "M09", zona: "Z3", dia: 5, kilometros: 23.0, retraso: -1},
      %{repartidor: "M10", zona: "Z4", dia: 5, kilometros: 36.0, retraso: 5},

      # --- Día 6 ---
      %{repartidor: "M01", zona: "Z1", dia: 6, kilometros: 24.0, retraso: 0},
      %{repartidor: "M02", zona: "Z3", dia: 6, kilometros: 29.0, retraso: -11},
      %{repartidor: "M03", zona: "Z3", dia: 6, kilometros: 18.0, retraso: 7},
      %{repartidor: "M04", zona: "Z4", dia: 6, kilometros: 31.0, retraso: -3},
      %{repartidor: "M05", zona: "Z4", dia: 6, kilometros: 25.0, retraso: 15},
      %{repartidor: "M06", zona: "Z3", dia: 6, kilometros: 20.0, retraso: -8},
      %{repartidor: "M07", zona: "Z1", dia: 6, kilometros: 37.0, retraso: 1},
      %{repartidor: "M08", zona: "Z2", dia: 6, kilometros: 16.0, retraso: 0},
      %{repartidor: "M09", zona: "Z4", dia: 6, kilometros: 28.0, retraso: -5},
      %{repartidor: "M10", zona: "Z3", dia: 6, kilometros: 32.0, retraso: 11},

      # --- Servicios Inválidos (mínimo 2 por cada motivo) ---
      # Motivo 1: :repartidor_desconocido
      %{repartidor: "M99", zona: "Z1", dia: 1, kilometros: 15.0, retraso: 0},
      %{repartidor: "M88", zona: "Z2", dia: 2, kilometros: 20.0, retraso: 5},

      # Motivo 2: :zona_desconocida
      %{repartidor: "M01", zona: "Z9", dia: 1, kilometros: 18.0, retraso: 0},
      %{repartidor: "M02", zona: "Z8", dia: 3, kilometros: 22.0, retraso: 10},

      # Motivo 3: :dia_invalido
      %{repartidor: "M03", zona: "Z1", dia: 0, kilometros: 10.0, retraso: 0},
      %{repartidor: "M04", zona: "Z2", dia: 7, kilometros: 12.0, retraso: 5},

      # Motivo 4: :kilometros_fuera_de_rango
      %{repartidor: "M05", zona: "Z3", dia: 1, kilometros: -5.0, retraso: 0},
      %{repartidor: "M06", zona: "Z4", dia: 2, kilometros: 50.0, retraso: 10},

      # Motivo 5: :retraso_invalido
      %{repartidor: "M07", zona: "Z1", dia: 3, kilometros: 20.0, retraso: -40},
      %{repartidor: "M08", zona: "Z2", dia: 4, kilometros: 15.0, retraso: 200}
    ]
  end
end

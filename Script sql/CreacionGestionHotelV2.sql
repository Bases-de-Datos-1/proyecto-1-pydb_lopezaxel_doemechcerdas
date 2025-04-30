-- Verifica y crea la base de datos si no existe
IF DB_ID('SistemaGestionHotelera') IS NULL
BEGIN
    CREATE DATABASE SistemaGestionHotelera;
END;
GO

USE SistemaGestionHotelera;
GO

--------------------------------------------------------------------------------
-- Tabla: Establecimientos (Datos de los establecimientos de hospedaje)
--------------------------------------------------------------------------------
CREATE TABLE Establecimientos (
    EstablecimientoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreHotel NVARCHAR(100) NOT NULL,
    CedulaJuridica NVARCHAR(20) NOT NULL UNIQUE,
    Tipo NVARCHAR(50) NOT NULL,  -- Ej: Hotel, Hostal, Casa, etc.
    Provincia NVARCHAR(50) NOT NULL,
    Canton NVARCHAR(50) NOT NULL,
    Distrito NVARCHAR(50) NOT NULL,
    Barrio NVARCHAR(50) NOT NULL,
    Senas NVARCHAR(200) NOT NULL,
    Referencia NVARCHAR(100) NULL,
    Telefonos NVARCHAR(100) NULL, -- Lista de teléfonos; se puede normalizar en otra tabla
    Email NVARCHAR(100) NULL,
    URLSitioWeb NVARCHAR(100) NULL,
    Facebook NVARCHAR(100) NULL,
    Instagram NVARCHAR(100) NULL,
    YouTube NVARCHAR(100) NULL,
    TikTok NVARCHAR(100) NULL,
    Airbnb NVARCHAR(100) NULL,
    Threads NVARCHAR(100) NULL,
    X_Red NVARCHAR(100) NULL,
    ListaServicios NVARCHAR(200) NULL  -- Ej: piscina, WiFi, restaurante, etc.
);
GO

--------------------------------------------------------------------------------
-- Tabla: TiposHabitacion (Definición de tipos de habitaciones)
--------------------------------------------------------------------------------
CREATE TABLE TiposHabitacion (
    TipoHabitacionID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(200) NULL,
    Comodidades NVARCHAR(200) NULL,  -- Ej: WiFi en habitación, A/C, ventilador, etc.
    Precio DECIMAL(10,2) NOT NULL,
    Fotos NVARCHAR(200) NULL        -- Ruta o URL de imagen(es)
);
GO

--------------------------------------------------------------------------------
-- Tabla: Habitaciones (Asignación de habitaciones a cada establecimiento)
--------------------------------------------------------------------------------
CREATE TABLE Habitaciones (
    HabitacionID INT IDENTITY(1,1) PRIMARY KEY,
    EstablecimientoID INT NOT NULL,
    NumeroHabitacion NVARCHAR(20) NOT NULL, -- Número o código de la habitación
    TipoHabitacionID INT NOT NULL,
    CONSTRAINT FK_Habitaciones_Establecimientos FOREIGN KEY (EstablecimientoID)
       REFERENCES Establecimientos(EstablecimientoID),
    CONSTRAINT FK_Habitaciones_TiposHabitacion FOREIGN KEY (TipoHabitacionID)
       REFERENCES TiposHabitacion(TipoHabitacionID)
);
GO

--------------------------------------------------------------------------------
-- Tabla: Clientes (Información de los clientes)
--------------------------------------------------------------------------------
CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(50) NOT NULL,
    PrimerApellido NVARCHAR(50) NOT NULL,
    SegundoApellido NVARCHAR(50) NULL,
    FechaNacimiento DATE NOT NULL,
    TipoIdentificacion NVARCHAR(50) NOT NULL,
    Cedula NVARCHAR(20) NOT NULL UNIQUE,
    PaisResidencia NVARCHAR(50) NOT NULL,
    -- Si el cliente es costarricense, se registran estos datos:
    Provincia NVARCHAR(50) NULL,
    Canton NVARCHAR(50) NULL,
    Distrito NVARCHAR(50) NULL,
    Telefono1 NVARCHAR(20) NULL,
    Telefono2 NVARCHAR(20) NULL,
    Telefono3 NVARCHAR(20) NULL,
    Email NVARCHAR(100) NOT NULL
);
GO

--------------------------------------------------------------------------------
-- Tabla: Reservaciones (Registro de reservaciones de habitaciones)
--------------------------------------------------------------------------------
CREATE TABLE Reservaciones (
    ReservacionID INT IDENTITY(1,1) PRIMARY KEY,
    NumeroReserva NVARCHAR(50) NOT NULL UNIQUE,  -- Número de reserva único para búsquedas
    ClienteID INT NOT NULL,
    HabitacionID INT NOT NULL,
    FechaIngreso DATETIME NOT NULL,
    CantidadPersonas INT NOT NULL,
    PoseeVehiculo BIT NOT NULL,  -- 0 = No, 1 = Sí
    FechaSalida DATETIME NOT NULL,
    CONSTRAINT FK_Reservaciones_Clientes FOREIGN KEY (ClienteID)
       REFERENCES Clientes(ClienteID),
    CONSTRAINT FK_Reservaciones_Habitaciones FOREIGN KEY (HabitacionID)
       REFERENCES Habitaciones(HabitacionID)
);
GO

--------------------------------------------------------------------------------
-- Tabla: Facturacion (Datos de la facturación asociados a una reservación)
--------------------------------------------------------------------------------
CREATE TABLE Facturacion (
    FacturacionID INT IDENTITY(1,1) PRIMARY KEY,
    ReservacionID INT NOT NULL,
    NochesEstadia INT NOT NULL, -- Se puede calcular en función de FechaIngreso y FechaSalida
    ImporteTotal DECIMAL(10,2) NOT NULL,
    MetodoPago NVARCHAR(50) NOT NULL, -- Ej: 'efectivo' o 'tarjeta de crédito'
    CONSTRAINT FK_Facturacion_Reservaciones FOREIGN KEY (ReservacionID)
       REFERENCES Reservaciones(ReservacionID)
);
GO

-- Restricción para garantizar que el método de pago solo sea 'efectivo' o 'tarjeta de crédito'
ALTER TABLE Facturacion
ADD CONSTRAINT CHK_MetodoPago CHECK (MetodoPago IN ('efectivo', 'tarjeta de crédito'));
GO

--------------------------------------------------------------------------------
-- Tabla: ActividadesRecreacion (Servicios de actividades de recreación)
-- Ahora vinculada directamente a Establecimientos
--------------------------------------------------------------------------------
CREATE TABLE ActividadesRecreacion (
    ActividadID INT IDENTITY(1,1) PRIMARY KEY,
    EstablecimientoID INT NOT NULL,
    NombreEmpresa NVARCHAR(100) NOT NULL,
    CedulaJuridica NVARCHAR(20) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    Telefono NVARCHAR(20) NOT NULL,
    NombreContacto NVARCHAR(100) NOT NULL,
    Provincia NVARCHAR(50) NOT NULL,
    Canton NVARCHAR(50) NOT NULL,
    Distrito NVARCHAR(50) NOT NULL,
    Senas NVARCHAR(200) NOT NULL,
    TipoActividad NVARCHAR(200) NOT NULL,  -- Puede incluir varias actividades
    Descripcion NVARCHAR(200) NULL,
    Precio DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_ActRec_Estab FOREIGN KEY (EstablecimientoID)
       REFERENCES Establecimientos(EstablecimientoID)
);
GO

--------------------------------------------------------------------------------
-- Índices adicionales para optimizar búsquedas
--------------------------------------------------------------------------------
CREATE INDEX IDX_Establecimientos_Nombre ON Establecimientos(NombreHotel);
CREATE INDEX IDX_Clientes_Cedula ON Clientes(Cedula);
CREATE INDEX IDX_Reservaciones_NumeroReserva ON Reservaciones(NumeroReserva);
CREATE INDEX IDX_ActRec_Estab ON ActividadesRecreacion(EstablecimientoID);
GO

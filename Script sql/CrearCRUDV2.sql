-- ==========================================================
-- Script de CRUD completo para todas las entidades
-- Incluye procedimientos almacenados y pruebas de funcionalidad
-- Base de datos: SistemaGestionHotelera
-- ==========================================================

USE SistemaGestionHotelera;
GO

--------------------------------------------------------------------------------
-- 1. CRUD: Establecimientos
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateEstablecimiento','P') IS NOT NULL DROP PROCEDURE sp_CreateEstablecimiento;
GO
CREATE PROCEDURE sp_CreateEstablecimiento
  @NombreHotel     NVARCHAR(100),
  @CedulaJuridica  NVARCHAR(20),
  @Tipo            NVARCHAR(50),
  @Provincia       NVARCHAR(50),
  @Canton          NVARCHAR(50),
  @Distrito        NVARCHAR(50),
  @Barrio          NVARCHAR(50),
  @Senas           NVARCHAR(200),
  @Referencia      NVARCHAR(100)=NULL,
  @Telefonos       NVARCHAR(100)=NULL,
  @Email           NVARCHAR(100)=NULL,
  @URLSitioWeb     NVARCHAR(100)=NULL,
  @Facebook        NVARCHAR(100)=NULL,
  @Instagram       NVARCHAR(100)=NULL,
  @YouTube         NVARCHAR(100)=NULL,
  @TikTok          NVARCHAR(100)=NULL,
  @Airbnb          NVARCHAR(100)=NULL,
  @Threads         NVARCHAR(100)=NULL,
  @X_Red           NVARCHAR(100)=NULL,
  @ListaServicios  NVARCHAR(200)=NULL
AS
BEGIN
  INSERT INTO Establecimientos(
    NombreHotel, CedulaJuridica, Tipo,
    Provincia, Canton, Distrito, Barrio, Senas,
    Referencia, Telefonos, Email, URLSitioWeb,
    Facebook, Instagram, YouTube, TikTok,
    Airbnb, Threads, X_Red, ListaServicios
  ) VALUES (
    @NombreHotel, @CedulaJuridica, @Tipo,
    @Provincia, @Canton, @Distrito, @Barrio, @Senas,
    @Referencia, @Telefonos, @Email, @URLSitioWeb,
    @Facebook, @Instagram, @YouTube, @TikTok,
    @Airbnb, @Threads, @X_Red, @ListaServicios
  );
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetEstablecimientos','P') IS NOT NULL DROP PROCEDURE sp_GetEstablecimientos;
GO
CREATE PROCEDURE sp_GetEstablecimientos
  @Nombre    NVARCHAR(100)=NULL,
  @Provincia NVARCHAR(50)=NULL,
  @Tipo      NVARCHAR(50)=NULL
AS
BEGIN
  SELECT * FROM Establecimientos
  WHERE (@Nombre    IS NULL OR NombreHotel LIKE '%'+@Nombre+'%')
    AND (@Provincia IS NULL OR Provincia = @Provincia)
    AND (@Tipo      IS NULL OR Tipo = @Tipo);
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateEstablecimiento','P') IS NOT NULL DROP PROCEDURE sp_UpdateEstablecimiento;
GO
CREATE PROCEDURE sp_UpdateEstablecimiento
  @EstablecimientoID INT,
  @NombreHotel       NVARCHAR(100)=NULL,
  @Tipo              NVARCHAR(50)=NULL,
  @Provincia         NVARCHAR(50)=NULL,
  @Canton            NVARCHAR(50)=NULL,
  @Distrito          NVARCHAR(50)=NULL,
  @ListaServicios    NVARCHAR(200)=NULL,
  @Facebook          NVARCHAR(100)=NULL,
  @Instagram         NVARCHAR(100)=NULL,
  @YouTube           NVARCHAR(100)=NULL,
  @TikTok            NVARCHAR(100)=NULL,
  @Airbnb            NVARCHAR(100)=NULL,
  @Threads           NVARCHAR(100)=NULL,
  @X_Red             NVARCHAR(100)=NULL
AS
BEGIN
  UPDATE Establecimientos
  SET NombreHotel    = COALESCE(@NombreHotel, NombreHotel),
      Tipo           = COALESCE(@Tipo, Tipo),
      Provincia      = COALESCE(@Provincia, Provincia),
      Canton         = COALESCE(@Canton, Canton),
      Distrito       = COALESCE(@Distrito, Distrito),
      ListaServicios = COALESCE(@ListaServicios, ListaServicios),
      Facebook       = COALESCE(@Facebook, Facebook),
      Instagram      = COALESCE(@Instagram, Instagram),
      YouTube        = COALESCE(@YouTube, YouTube),
      TikTok         = COALESCE(@TikTok, TikTok),
      Airbnb         = COALESCE(@Airbnb, Airbnb),
      Threads        = COALESCE(@Threads, Threads),
      X_Red          = COALESCE(@X_Red, X_Red)
  WHERE EstablecimientoID=@EstablecimientoID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteEstablecimiento','P') IS NOT NULL DROP PROCEDURE sp_DeleteEstablecimiento;
GO
CREATE PROCEDURE sp_DeleteEstablecimiento
  @EstablecimientoID INT
AS
BEGIN
  DELETE FROM Establecimientos WHERE EstablecimientoID=@EstablecimientoID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- 2. CRUD: TiposHabitacion
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateTipoHabitacion','P') IS NOT NULL DROP PROCEDURE sp_CreateTipoHabitacion;
GO
CREATE PROCEDURE sp_CreateTipoHabitacion
  @Nombre       NVARCHAR(50),
  @Descripcion  NVARCHAR(200)=NULL,
  @Comodidades  NVARCHAR(200)=NULL,
  @Precio       DECIMAL(10,2),
  @Fotos        NVARCHAR(200)=NULL
AS
BEGIN
  INSERT INTO TiposHabitacion(Nombre,Descripcion,Comodidades,Precio,Fotos)
  VALUES(@Nombre,@Descripcion,@Comodidades,@Precio,@Fotos);
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetTiposHabitacion','P') IS NOT NULL DROP PROCEDURE sp_GetTiposHabitacion;
GO
CREATE PROCEDURE sp_GetTiposHabitacion
  @Nombre    NVARCHAR(50)=NULL,
  @PrecioMin DECIMAL(10,2)=NULL,
  @PrecioMax DECIMAL(10,2)=NULL
AS
BEGIN
  SELECT * FROM TiposHabitacion
  WHERE (@Nombre IS NULL OR Nombre LIKE '%'+@Nombre+'%')
    AND (@PrecioMin IS NULL OR Precio>=@PrecioMin)
    AND (@PrecioMax IS NULL OR Precio<=@PrecioMax);
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateTipoHabitacion','P') IS NOT NULL DROP PROCEDURE sp_UpdateTipoHabitacion;
GO
CREATE PROCEDURE sp_UpdateTipoHabitacion
  @TipoHabitacionID INT,
  @Nombre           NVARCHAR(50)=NULL,
  @Descripcion      NVARCHAR(200)=NULL,
  @Comodidades      NVARCHAR(200)=NULL,
  @Precio           DECIMAL(10,2)=NULL,
  @Fotos            NVARCHAR(200)=NULL
AS
BEGIN
  UPDATE TiposHabitacion
  SET Nombre      = COALESCE(@Nombre, Nombre),
      Descripcion = COALESCE(@Descripcion, Descripcion),
      Comodidades = COALESCE(@Comodidades, Comodidades),
      Precio      = COALESCE(@Precio, Precio),
      Fotos       = COALESCE(@Fotos, Fotos)
  WHERE TipoHabitacionID=@TipoHabitacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteTipoHabitacion','P') IS NOT NULL DROP PROCEDURE sp_DeleteTipoHabitacion;
GO
CREATE PROCEDURE sp_DeleteTipoHabitacion
  @TipoHabitacionID INT
AS
BEGIN
  DELETE FROM TiposHabitacion WHERE TipoHabitacionID=@TipoHabitacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- 3. CRUD: Habitaciones
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateHabitacion','P') IS NOT NULL DROP PROCEDURE sp_CreateHabitacion;
GO
CREATE PROCEDURE sp_CreateHabitacion
  @NumeroHabitacion  NVARCHAR(20),
  @EstablecimientoID INT,
  @TipoHabitacionID  INT
AS
BEGIN
  INSERT INTO Habitaciones(NumeroHabitacion,EstablecimientoID,TipoHabitacionID)
  VALUES(@NumeroHabitacion,@EstablecimientoID,@TipoHabitacionID);
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetHabitaciones','P') IS NOT NULL DROP PROCEDURE sp_GetHabitaciones;
GO
CREATE PROCEDURE sp_GetHabitaciones
  @EstablecimientoID INT=NULL,
  @TipoHabitacionID  INT=NULL
AS
BEGIN
  SELECT h.HabitacionID,h.NumeroHabitacion,e.NombreHotel,th.Nombre AS Tipo
  FROM Habitaciones h
  JOIN Establecimientos e ON h.EstablecimientoID=e.EstablecimientoID
  JOIN TiposHabitacion th ON h.TipoHabitacionID=th.TipoHabitacionID
  WHERE (@EstablecimientoID IS NULL OR h.EstablecimientoID=@EstablecimientoID)
    AND (@TipoHabitacionID  IS NULL OR h.TipoHabitacionID=@TipoHabitacionID);
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateHabitacion','P') IS NOT NULL DROP PROCEDURE sp_UpdateHabitacion;
GO
CREATE PROCEDURE sp_UpdateHabitacion
  @HabitacionID      INT,
  @NumeroHabitacion  NVARCHAR(20)=NULL,
  @EstablecimientoID INT=NULL,
  @TipoHabitacionID  INT=NULL
AS
BEGIN
  UPDATE Habitaciones
  SET NumeroHabitacion  = COALESCE(@NumeroHabitacion, NumeroHabitacion),
      EstablecimientoID = COALESCE(@EstablecimientoID,EstablecimientoID),
      TipoHabitacionID  = COALESCE(@TipoHabitacionID,TipoHabitacionID)
  WHERE HabitacionID=@HabitacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteHabitacion','P') IS NOT NULL DROP PROCEDURE sp_DeleteHabitacion;
GO
CREATE PROCEDURE sp_DeleteHabitacion
  @HabitacionID INT
AS
BEGIN
  DELETE FROM Habitaciones WHERE HabitacionID=@HabitacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- 4. CRUD: Clientes
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateCliente','P') IS NOT NULL DROP PROCEDURE sp_CreateCliente;
GO
CREATE PROCEDURE sp_CreateCliente
  @Nombre            NVARCHAR(50),
  @PrimerApellido    NVARCHAR(50),
  @SegundoApellido   NVARCHAR(50)=NULL,
  @FechaNacimiento   DATE,
  @TipoIdentificacion NVARCHAR(50),
  @Cedula            NVARCHAR(20),
  @PaisResidencia    NVARCHAR(50),
  @Provincia         NVARCHAR(50)=NULL,
  @Canton            NVARCHAR(50)=NULL,
  @Distrito          NVARCHAR(50)=NULL,
  @Telefono1         NVARCHAR(20)=NULL,
  @Telefono2         NVARCHAR(20)=NULL,
  @Telefono3         NVARCHAR(20)=NULL,
  @Email             NVARCHAR(100)
AS
BEGIN
  INSERT INTO Clientes(
    Nombre,PrimerApellido,SegundoApellido,FechaNacimiento,
    TipoIdentificacion,Cedula,PaisResidencia,Provincia,Canton,Distrito,
    Telefono1,Telefono2,Telefono3,Email
  ) VALUES(
    @Nombre,@PrimerApellido,@SegundoApellido,@FechaNacimiento,
    @TipoIdentificacion,@Cedula,@PaisResidencia,@Provincia,@Canton,@Distrito,
    @Telefono1,@Telefono2,@Telefono3,@Email
  );
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetClientes','P') IS NOT NULL DROP PROCEDURE sp_GetClientes;
GO
CREATE PROCEDURE sp_GetClientes
  @Cedula         NVARCHAR(20)=NULL,
  @Nombre         NVARCHAR(50)=NULL,
  @PaisResidencia NVARCHAR(50)=NULL
AS
BEGIN
  SELECT * FROM Clientes
  WHERE (@Cedula         IS NULL OR Cedula         = @Cedula)
    AND (@Nombre         IS NULL OR Nombre        LIKE '%'+@Nombre+'%')
    AND (@PaisResidencia IS NULL OR PaisResidencia = @PaisResidencia);
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateCliente','P') IS NOT NULL DROP PROCEDURE sp_UpdateCliente;
GO
CREATE PROCEDURE sp_UpdateCliente
  @ClienteID         INT,
  @Nombre            NVARCHAR(50)=NULL,
  @PrimerApellido    NVARCHAR(50)=NULL,
  @SegundoApellido   NVARCHAR(50)=NULL,
  @Provincia         NVARCHAR(50)=NULL,
  @Canton            NVARCHAR(50)=NULL,
  @Distrito          NVARCHAR(50)=NULL,
  @Telefono1         NVARCHAR(20)=NULL,
  @Telefono2         NVARCHAR(20)=NULL,
  @Telefono3         NVARCHAR(20)=NULL,
  @Email             NVARCHAR(100)=NULL
AS
BEGIN
  UPDATE Clientes
  SET Nombre          = COALESCE(@Nombre, Nombre),
      PrimerApellido  = COALESCE(@PrimerApellido, PrimerApellido),
      SegundoApellido = COALESCE(@SegundoApellido,SegundoApellido),
      Provincia       = COALESCE(@Provincia, Provincia),
      Canton          = COALESCE(@Canton, Canton),
      Distrito        = COALESCE(@Distrito,Distrito),
      Telefono1       = COALESCE(@Telefono1, Telefono1),
      Telefono2       = COALESCE(@Telefono2, Telefono2),
      Telefono3       = COALESCE(@Telefono3, Telefono3),
      Email           = COALESCE(@Email, Email)
  WHERE ClienteID=@ClienteID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteCliente','P') IS NOT NULL DROP PROCEDURE sp_DeleteCliente;
GO
CREATE PROCEDURE sp_DeleteCliente
  @ClienteID INT
AS
BEGIN
  DELETE FROM Clientes WHERE ClienteID=@ClienteID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- 5. CRUD: Reservaciones
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateReservacion','P') IS NOT NULL DROP PROCEDURE sp_CreateReservacion;
GO
CREATE PROCEDURE sp_CreateReservacion
  @NumeroReserva     NVARCHAR(50),
  @ClienteID         INT,
  @HabitacionID      INT,
  @FechaIngreso      DATETIME,
  @FechaSalida       DATETIME,
  @CantidadPersonas  INT,
  @PoseeVehiculo     BIT
AS
BEGIN
  INSERT INTO Reservaciones(
    NumeroReserva,ClienteID,HabitacionID,FechaIngreso,FechaSalida,CantidadPersonas,PoseeVehiculo
  ) VALUES(
    @NumeroReserva,@ClienteID,@HabitacionID,@FechaIngreso,@FechaSalida,@CantidadPersonas,@PoseeVehiculo
  );
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetReservaciones','P') IS NOT NULL DROP PROCEDURE sp_GetReservaciones;
GO
CREATE PROCEDURE sp_GetReservaciones
  @ClienteID INT=NULL,
  @Desde     DATETIME=NULL,
  @Hasta     DATETIME=NULL
AS
BEGIN
  SELECT r.ReservacionID, r.NumeroReserva,
         c.Nombre+' '+c.PrimerApellido AS Cliente,
         h.NumeroHabitacion AS Habitacion,
         r.FechaIngreso, r.FechaSalida,
         r.CantidadPersonas,
         CASE WHEN r.PoseeVehiculo=1 THEN 'Sí' ELSE 'No' END AS Vehiculo
  FROM Reservaciones r
  JOIN Clientes c     ON r.ClienteID=c.ClienteID
  JOIN Habitaciones h ON r.HabitacionID=h.HabitacionID
  WHERE (@ClienteID IS NULL OR r.ClienteID=@ClienteID)
    AND (@Desde      IS NULL OR r.FechaIngreso>=@Desde)
    AND (@Hasta      IS NULL OR r.FechaSalida<=@Hasta);
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateReservacion','P') IS NOT NULL DROP PROCEDURE sp_UpdateReservacion;
GO
CREATE PROCEDURE sp_UpdateReservacion
  @ReservacionID     INT,
  @FechaIngreso      DATETIME=NULL,
  @FechaSalida       DATETIME=NULL,
  @CantidadPersonas  INT=NULL,
  @PoseeVehiculo     BIT=NULL
AS
BEGIN
  UPDATE Reservaciones
  SET FechaIngreso     = COALESCE(@FechaIngreso, FechaIngreso),
      FechaSalida      = COALESCE(@FechaSalida, FechaSalida),
      CantidadPersonas = COALESCE(@CantidadPersonas, CantidadPersonas),
      PoseeVehiculo    = COALESCE(@PoseeVehiculo, PoseeVehiculo)
  WHERE ReservacionID=@ReservacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteReservacion','P') IS NOT NULL DROP PROCEDURE sp_DeleteReservacion;
GO
CREATE PROCEDURE sp_DeleteReservacion
  @ReservacionID INT
AS
BEGIN
  DELETE FROM Reservaciones WHERE ReservacionID=@ReservacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- 6. CRUD: Facturacion
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateFacturacion','P') IS NOT NULL DROP PROCEDURE sp_CreateFacturacion;
GO
CREATE PROCEDURE sp_CreateFacturacion
  @ReservacionID INT,
  @NochesEstadia INT,
  @ImporteTotal  DECIMAL(10,2),
  @MetodoPago    NVARCHAR(50)
AS
BEGIN
  INSERT INTO Facturacion(ReservacionID,NochesEstadia,ImporteTotal,MetodoPago)
  VALUES(@ReservacionID,@NochesEstadia,@ImporteTotal,@MetodoPago);
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetFacturacion','P') IS NOT NULL DROP PROCEDURE sp_GetFacturacion;
GO
CREATE PROCEDURE sp_GetFacturacion
  @Desde      DATETIME=NULL,
  @Hasta      DATETIME=NULL,
  @MetodoPago NVARCHAR(50)=NULL
AS
BEGIN
  SELECT f.FacturacionID, r.NumeroReserva, f.NochesEstadia, f.ImporteTotal, f.MetodoPago
  FROM Facturacion f
  JOIN Reservaciones r ON f.ReservacionID=r.ReservacionID
  WHERE (@Desde      IS NULL OR r.FechaIngreso>=@Desde)
    AND (@Hasta      IS NULL OR r.FechaSalida<=@Hasta)
    AND (@MetodoPago IS NULL OR f.MetodoPago=@MetodoPago);
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateFacturacion','P') IS NOT NULL DROP PROCEDURE sp_UpdateFacturacion;
GO
CREATE PROCEDURE sp_UpdateFacturacion
  @FacturacionID INT,
  @NochesEstadia INT=NULL,
  @ImporteTotal  DECIMAL(10,2)=NULL,
  @MetodoPago    NVARCHAR(50)=NULL
AS
BEGIN
  UPDATE Facturacion
  SET NochesEstadia = COALESCE(@NochesEstadia, NochesEstadia),
      ImporteTotal  = COALESCE(@ImporteTotal, ImporteTotal),
      MetodoPago    = COALESCE(@MetodoPago, MetodoPago)
  WHERE FacturacionID=@FacturacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteFacturacion','P') IS NOT NULL DROP PROCEDURE sp_DeleteFacturacion;
GO
CREATE PROCEDURE sp_DeleteFacturacion
  @FacturacionID INT
AS
BEGIN
  DELETE FROM Facturacion WHERE FacturacionID=@FacturacionID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- 7. CRUD: ActividadesRecreacion
--------------------------------------------------------------------------------
-- CREATE
IF OBJECT_ID('sp_CreateActividad','P') IS NOT NULL DROP PROCEDURE sp_CreateActividad;
GO
CREATE PROCEDURE sp_CreateActividad
  @EstablecimientoID INT,
  @NombreEmpresa     NVARCHAR(100),
  @CedulaJuridica    NVARCHAR(20),
  @Email             NVARCHAR(100),
  @Telefono          NVARCHAR(20),
  @NombreContacto    NVARCHAR(100),
  @Provincia         NVARCHAR(50),
  @Canton            NVARCHAR(50),
  @Distrito          NVARCHAR(50),
  @Senas             NVARCHAR(200),
  @TipoActividad     NVARCHAR(200),
  @Descripcion       NVARCHAR(200)=NULL,
  @Precio            DECIMAL(10,2)
AS
BEGIN
  INSERT INTO ActividadesRecreacion(
    EstablecimientoID,NombreEmpresa,CedulaJuridica,Email,Telefono,
    NombreContacto,Provincia,Canton,Distrito,Senas,TipoActividad,Descripcion,Precio
  ) VALUES(
    @EstablecimientoID,@NombreEmpresa,@CedulaJuridica,@Email,@Telefono,
    @NombreContacto,@Provincia,@Canton,@Distrito,@Senas,@TipoActividad,@Descripcion,@Precio
  );
  SELECT SCOPE_IDENTITY() AS NewID;
END;
GO

-- READ
IF OBJECT_ID('sp_GetActividades','P') IS NOT NULL DROP PROCEDURE sp_GetActividades;
GO
CREATE PROCEDURE sp_GetActividades
  @EstablecimientoID INT=NULL,
  @TipoActividad     NVARCHAR(50)=NULL
AS
BEGIN
  SELECT a.ActividadID, e.NombreHotel, a.NombreEmpresa, a.TipoActividad, a.Precio
  FROM ActividadesRecreacion a
  JOIN Establecimientos e ON a.EstablecimientoID=e.EstablecimientoID
  WHERE (@EstablecimientoID IS NULL OR a.EstablecimientoID=@EstablecimientoID)
    AND (@TipoActividad     IS NULL OR a.TipoActividad LIKE '%'+@TipoActividad+'%');
END;
GO

-- UPDATE
IF OBJECT_ID('sp_UpdateActividad','P') IS NOT NULL DROP PROCEDURE sp_UpdateActividad;
GO
CREATE PROCEDURE sp_UpdateActividad
  @ActividadID       INT,
  @NombreEmpresa     NVARCHAR(100)=NULL,
  @Email             NVARCHAR(100)=NULL,
  @Telefono          NVARCHAR(20)=NULL,
  @NombreContacto    NVARCHAR(100)=NULL,
  @Provincia         NVARCHAR(50)=NULL,
  @Canton            NVARCHAR(50)=NULL,
  @Distrito          NVARCHAR(50)=NULL,
  @Senas             NVARCHAR(200)=NULL,
  @TipoActividad     NVARCHAR(200)=NULL,
  @Descripcion       NVARCHAR(200)=NULL,
  @Precio            DECIMAL(10,2)=NULL
AS
BEGIN
  UPDATE ActividadesRecreacion
  SET NombreEmpresa  = COALESCE(@NombreEmpresa, NombreEmpresa),
      Email          = COALESCE(@Email, Email),
      Telefono       = COALESCE(@Telefono, Telefono),
      NombreContacto = COALESCE(@NombreContacto, NombreContacto),
      Provincia      = COALESCE(@Provincia, Provincia),
      Canton         = COALESCE(@Canton, Canton),
      Distrito       = COALESCE(@Distrito, Distrito),
      Senas          = COALESCE(@Senas, Senas),
      TipoActividad  = COALESCE(@TipoActividad, TipoActividad),
      Descripcion    = COALESCE(@Descripcion, Descripcion),
      Precio         = COALESCE(@Precio, Precio)
  WHERE ActividadID=@ActividadID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

-- DELETE
IF OBJECT_ID('sp_DeleteActividad','P') IS NOT NULL DROP PROCEDURE sp_DeleteActividad;
GO
CREATE PROCEDURE sp_DeleteActividad
  @ActividadID INT
AS
BEGIN
  DELETE FROM ActividadesRecreacion WHERE ActividadID=@ActividadID;
  SELECT @@ROWCOUNT AS RowsAffected;
END;
GO

--------------------------------------------------------------------------------
-- PRUEBAS DE FUNCIONALIDAD CRUD (ejemplos)
--------------------------------------------------------------------------------
-- Establecimientos
EXEC sp_CreateEstablecimiento 'Test Hotel', '123456789','Hotel','Limón','Limón','Limón','Centro','Al lado del mar','N/A','8888-8888','test@hotel.com','https://hotel.test','fb/test','insta/test','yt/test','tt/test','abnb/test','thrds/test','x/test','WiFi;Desayuno';
EXEC sp_GetEstablecimientos @Nombre='Test';
EXEC sp_UpdateEstablecimiento 1, @Facebook='fb/updated';
--EXEC sp_DeleteEstablecimiento 1;

-- TiposHabitacion
EXEC sp_CreateTipoHabitacion 'Presidencial', 'Espacioso', 'WiFi,A/C', 120000, NULL;
EXEC sp_GetTiposHabitacion @PrecioMin=100000;
EXEC sp_UpdateTipoHabitacion 1, @Precio=130000;
--EXEC sp_DeleteTipoHabitacion 1;

-- Habitaciones
EXEC sp_CreateHabitacion '999',1,1;
EXEC sp_GetHabitaciones @EstablecimientoID=1;
EXEC sp_UpdateHabitacion 1, @NumeroHabitacion='998';
--EXEC sp_DeleteHabitacion 1;

-- Clientes
EXEC sp_CreateCliente 'Carlos','Molina','Rojas','1980-01-01','Cédula','20202020','Costa Rica','Limon','Siquirres','Siquirres','123','111','222','Carlos@gmail';
EXEC sp_GetClientes @PaisResidencia='Costa Rica';
EXEC sp_UpdateCliente 1, @Email='cmolina@ejemplo.com';
--EXEC sp_DeleteCliente 1;

-- Reservaciones
EXEC sp_CreateReservacion 'RSV-5001',1,1,'2025-08-01 14:00:00','2025-08-03 11:00:00',2,0;
EXEC sp_GetReservaciones @Desde='2025-08-01', @Hasta='2025-08-31';
EXEC sp_UpdateReservacion 1, @CantidadPersonas=3;
--EXEC sp_DeleteReservacion 1;

-- Facturacion
EXEC sp_CreateFacturacion 1,2,90000,'efectivo';
EXEC sp_GetFacturacion @MetodoPago='efectivo';
EXEC sp_UpdateFacturacion 1, @ImporteTotal=95000;
--EXEC sp_DeleteFacturacion 1;

-- ActividadesRecreacion
EXEC sp_CreateActividad 1,'Adventure Tours','311112222','adv@tours','27770000','Laura Vega','Limón','Pococí','Guápiles','En el parque','Tour','Breve descripción',40000;
EXEC sp_GetActividades @EstablecimientoID=1;
EXEC sp_UpdateActividad 1, @Precio=45000;
--EXEC sp_DeleteActividad 1;

-- Descomentar deletes para probar esa funcionalidad

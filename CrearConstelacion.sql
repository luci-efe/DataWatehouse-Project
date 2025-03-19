USE AutopartesConstelacion;

DROP TABLE FactSalida;
DROP TABLE FactEntrada;
DROP TABLE FactFactura;
DROP TABLE DimSubSalida;
DROP TABLE DimSubEntrada;
DROP TABLE DimSubFactura;
DROP TABLE DimMedioEmbarque;
DROP TABLE DimCondicionPago;
DROP TABLE DimFecha;
DROP TABLE DimVendedor;
DROP TABLE DimCliente;
DROP TABLE DimArticulo;

-- Tabla de dimensión Artículo
CREATE TABLE DimArticulo (
    Clave char(20) NOT NULL,
    Descripcion varchar(150) NULL,
    Marca varchar(20) NULL,
    Tipo varchar(20) NULL,
    Grupo varchar(20) NULL,
    Clase varchar(20) NULL,
    Almacenable varchar(100) NULL,
    UMedInv varchar(20) NULL,
    UMedVta varchar(20) NULL,
    UMedCpa varchar(20) NULL,
    Moneda char(20) NULL,
    Precio numeric NULL,
    pctDescuento numeric NULL,
    UbicacionAlmacen varchar(20) NULL,
    UbicacionClave nchar(20) NULL,
    CONSTRAINT PK_DimArticulo PRIMARY KEY (Clave)
);

-- Tabla de dimensión Cliente
CREATE TABLE DimCliente (
    Clave char(20) NOT NULL,
    RazonSocial varchar(100) NULL,
    CalleNumero varchar(100) NULL,
    Colonia varchar(100) NULL,
    Ciudad varchar(100) NULL,
    Estado varchar(100) NULL,
    Pais varchar(100) NULL,
    CodigoPostal varchar(20) NULL,
    ClienteTipo varchar(20) NULL,
    ClienteGrupo varchar(20) NULL,
    Vendedor nchar(20) NULL,
    Moneda nchar(20) NULL,
    CondicionPago nchar(20) NULL,
    ZonaVenta nchar(20) NULL,
    CONSTRAINT PK_DimCliente PRIMARY KEY (Clave)
);

-- Tabla de dimensión Vendedor
CREATE TABLE DimVendedor (
    Clave char(20) NOT NULL,
    Nombre varchar(100) NOT NULL,
    CONSTRAINT PK_DimVendedor PRIMARY KEY (Clave)
);

-- Tabla de dimensión Fecha
CREATE TABLE DimFecha (
    FechaID int NOT NULL,
    Fecha date NOT NULL,
    Anio int NULL,
    Semestre int NULL,
    Cuatrimestre int NULL,
    Trimestre int NULL,
    Mes int NULL,
    Dia int NULL,
    NombreDia varchar(15) NULL,
    CONSTRAINT PK_DimFecha PRIMARY KEY (FechaID)
);

-- Tabla de dimensión Condición de Pago
CREATE TABLE DimCondicionPago (
    Clave char(20) NOT NULL,
    Descripcion varchar(100) NOT NULL,
    CONSTRAINT PK_DimCondicionPago PRIMARY KEY (Clave)
);

-- Tabla de dimensión Medio de Embarque
CREATE TABLE DimMedioEmbarque (
    Clave char(20) NOT NULL,
    Descripcion varchar(100) NOT NULL,
    CONSTRAINT PK_DimMedioEmbarque PRIMARY KEY (Clave)
);

-- Para FactFactura
CREATE TABLE DimSubFactura (
    FacturaFolio varchar(20) NOT NULL,
    CONSTRAINT PK_DimSubFactura PRIMARY KEY (FacturaFolio)
);

-- Para FactEntrada
CREATE TABLE DimSubEntrada (
    EntradaFolio varchar(20) NOT NULL,
    CONSTRAINT PK_DimSubEntrada PRIMARY KEY (EntradaFolio)
);

-- Para FactSalida
CREATE TABLE DimSubSalida (
    SalidaFolio varchar(20) NOT NULL,
    CONSTRAINT PK_DimSubSalida PRIMARY KEY (SalidaFolio)
);

-- Tabla de hechos para Facturación (FactFactura)
CREATE TABLE FactFactura (
    FacturaFolio varchar(20) NOT NULL,
    NumeroLinea int NOT NULL,
    FechaClave int NOT NULL,
    ClienteClave char(20) NOT NULL,
    VendedorClave char(20) NOT NULL,
    MedioEmbarqueClave char(20) NULL,
    CondicionPagoClave char(20) NOT NULL,
    ArticuloClave char(20) NOT NULL,
    Cantidad int NULL,
    PrecioUnitario decimal NULL,
    pctDescuentoGlobal decimal NULL,
    RacIVA decimal NULL,
    TotalImporte decimal NULL,
    TotalDescuento decimal NULL,
    TotalRetencion decimal NULL,
    Total decimal NULL,
    CONSTRAINT PK_FactFactura PRIMARY KEY (FacturaFolio, NumeroLinea),
    CONSTRAINT FK_FactFactura_DimFecha FOREIGN KEY (FechaClave) REFERENCES DimFecha(FechaID),
    CONSTRAINT FK_FactFactura_DimCliente FOREIGN KEY (ClienteClave) REFERENCES DimCliente(Clave),
    CONSTRAINT FK_FactFactura_DimVendedor FOREIGN KEY (VendedorClave) REFERENCES DimVendedor(Clave),
    CONSTRAINT FK_FactFactura_DimMedioEmbarque FOREIGN KEY (MedioEmbarqueClave) REFERENCES DimMedioEmbarque(Clave),
    CONSTRAINT FK_FactFactura_DimCondicionPago FOREIGN KEY (CondicionPagoClave) REFERENCES DimCondicionPago(Clave),
    CONSTRAINT FK_FactFactura_DimArticulo FOREIGN KEY (ArticuloClave) REFERENCES DimArticulo(Clave),
    CONSTRAINT FK_FactFactura_DimSubFactura FOREIGN KEY (FacturaFolio) REFERENCES DimSubFactura(FacturaFolio)
);

-- Tabla de hechos para Entradas (FactEntrada)
CREATE TABLE FactEntrada (
    EntradaFolio VARCHAR(20) NOT NULL,
    NumeroLinea INT NOT NULL,
    FechaClave INT NOT NULL,
    ClienteClave CHAR(20) NOT NULL,
    VendedorClave CHAR(20) NOT NULL,
    ArticuloClave CHAR(20) NOT NULL,
    Cantidad NUMERIC(9,2) NULL,
    PrecioUnitario DECIMAL(12,2) NULL,
    pctDescuento DECIMAL(5,2)  NULL,	
    pctDescuentoGlobal DECIMAL(5,2)  NULL,
    pctImpuesto DECIMAL(5,2)  NULL,
    TotalImporte DECIMAL(12,2) NULL,
    TotalDescuento DECIMAL(12,2) NULL,
    TotalRetencion DECIMAL(12,2) NULL,
    Total DECIMAL(12,2) NULL, 
    CONSTRAINT PK_FactEntrada PRIMARY KEY (EntradaFolio, NumeroLinea),
    CONSTRAINT FK_FactEntrada_DimFecha FOREIGN KEY (FechaClave) REFERENCES DimFecha(FechaID),
    CONSTRAINT FK_FactEntrada_DimCliente FOREIGN KEY (ClienteClave) REFERENCES DimCliente(Clave),
    CONSTRAINT FK_FactEntrada_DimVendedor FOREIGN KEY (VendedorClave) REFERENCES DimVendedor(Clave),
    CONSTRAINT FK_FactEntrada_DimArticulo FOREIGN KEY (ArticuloClave) REFERENCES DimArticulo(Clave),
	CONSTRAINT FK_FactEntrada_DimSubEntrada FOREIGN KEY (EntradaFolio) REFERENCES DimSubEntrada(EntradaFolio)
);

-- Tabla de hechos para Salidas (FactSalida)
CREATE TABLE FactSalida (
    SalidaFolio VARCHAR(20) NOT NULL,
    NumeroLinea INT NOT NULL,
    FechaClave INT NOT NULL,
    ClienteClave CHAR(20) NULL,
    VendedorClave CHAR(20) NULL,
    MedioEmbarqueClave CHAR(20) NULL,
    CondicionPagoClave CHAR(20) NULL,
    ArticuloClave CHAR(20) NOT NULL,
    Cantidad NUMERIC(9,2) NULL,
    PrecioUnitario DECIMAL(12,2) NULL,
    pctDescuento DECIMAL(5,2) NULL,
    pctDescuentoGlobal DECIMAL(5,2) NULL,
    pctImpuesto DECIMAL(5,2) NULL,
    TotalImporte DECIMAL(12,2) NULL,
    TotalDescuento DECIMAL(12,2) NULL,
    TotalRetencion DECIMAL(12,2) NULL,
    TotalImpuesto DECIMAL(12,2) NULL,
    Total DECIMAL(12,2) NULL,
    CONSTRAINT PK_FactSalida PRIMARY KEY (SalidaFolio, NumeroLinea),
    CONSTRAINT FK_FactSalida_DimFecha FOREIGN KEY (FechaClave) REFERENCES DimFecha(FechaID),
    CONSTRAINT FK_FactSalida_DimCliente FOREIGN KEY (ClienteClave) REFERENCES DimCliente(Clave),
    CONSTRAINT FK_FactSalida_DimVendedor FOREIGN KEY (VendedorClave) REFERENCES DimVendedor(Clave),
    CONSTRAINT FK_FactSalida_DimMedioEmbarque FOREIGN KEY (MedioEmbarqueClave) REFERENCES DimMedioEmbarque(Clave),
    CONSTRAINT FK_FactSalida_DimCondicionPago FOREIGN KEY (CondicionPagoClave) REFERENCES DimCondicionPago(Clave),
    CONSTRAINT FK_FactSalida_DimArticulo FOREIGN KEY (ArticuloClave) REFERENCES DimArticulo(Clave),
    CONSTRAINT FK_FactSalida_SubSalida FOREIGN KEY (SalidaFolio) REFERENCES DimSubSalida(SalidaFolio)
);

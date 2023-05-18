import { Logger } from '../common'


const { Sequelize } = require('sequelize');
const { Op } = require('sequelize');

const sequelize = new Sequelize('ev34', 'sa', 'Twinsociety235', {
    host: 'localhost',
    dialect: 'mssql'
});
const DataTypes = require('sequelize').DataTypes;

// se definen los modelos de las tablas involucradas en el select
const LotesProduccionLogs = sequelize.define('lotesProduccionLogs', {
      loteId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: true,
        autoIncrement: true,
        comment: null,
        field: "loteId"
      },
      productoId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "productoId",
        references: {
          key: "productoId",
          model: "productos"
        }
      },
      plantaId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "plantaId",
        references: {
          key: "plantaId",
          model: "plantas_model"
        }
      },
      cantidad: {
        type: DataTypes.DECIMAL,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "cantidad"
      },
      prodContratoId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "prodContratoId",
        references: {
          key: "prodContratoId",
          model: "contratosProduccion"
        }
      },
      costoProduccion: {
        type: DataTypes.DECIMAL(19,4),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "costoProduccion"
      },
      monedaId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "monedaId"
      },
      fecha: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "fecha"
      },
      enabled: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: 0,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "enabled"
      },
      createdAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "createdAt"
      },
      updatedAt: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "updatedAt"
      },
      computer: {
        type: DataTypes.STRING(20),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "computer"
      },
      username: {
        type: DataTypes.STRING(20),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "username"
      },
      checksum: {
        type: DataTypes.BLOB('tiny'),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "checksum"
      }
    }, {
        timestamps: false,
        freezeTableName: true,
    }
);

const Productos = sequelize.define('productos', {
    productoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: true,
      autoIncrement: true,
      comment: null,
      field: "productoId"
    },
    nombreId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "nombreId",
      references: {
        key: "nombreId",
        model: "nombres"
      }
    },
    enabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: 0,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "enabled"
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "createdAt"
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "updatedAt"
    },
    computer: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "computer"
    },
    username: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "username"
    },
    checksum: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "checksum"
    }
}, {
    timestamps: false,
    freezeTableName: true,
});

const PreciosProductosContrato = sequelize.define('preciosProductosContrato', {
    prodContratoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "prodContratoId",
      references: {
        key: "prodContratoId",
        model: "contratosProduccion"
      }
    },
    productoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "productoId",
      references: {
        key: "productoId",
        model: "productos"
      }
    },
    precio: {
      type: DataTypes.DECIMAL(19,4),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "precio"
    },
    areaEfectoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "areaEfectoId"
    },
    objectTypeId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "objectTypeId",
      references: {
        key: "objectTypeId",
        model: "objectTypes_model"
      }
    },
    fechaInicio: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "fechaInicio"
    },
    fechaFin: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "fechaFin"
    },
    monedaId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "monedaId",
      references: {
        key: "monedaId",
        model: "monedas_model"
      }
    },
    precioProductoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: true,
      autoIncrement: true,
      comment: null,
      field: "precioProductoId"
    },
    enabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: 0,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "enabled"
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "createdAt"
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "updatedAt"
    },
    computer: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "computer"
    },
    username: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "username"
    },
    checksum: {
      type: DataTypes.BLOB("tiny"),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "checksum"
    }
  }, {
    timestamps: false,
    freezeTableName: true,
});

const TiposDeCambio = sequelize.define("tiposDeCambio", {
    monedaBaseId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "monedaBaseId",
      references: {
        key: "monedaId",
        model: "monedas_model"
      }
    },
    conversion: {
      type: DataTypes.DECIMAL(19,4),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "conversion"
    },
    monedaCambioId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "monedaCambioId",
      references: {
        key: "monedaId",
        model: "monedas_model"
      }
    },
    validFrom: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "validFrom"
    },
    validTo: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "validTo"
    },
    enabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: 0,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "enabled"
    },
    tipoCambioId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: true,
      autoIncrement: true,
      comment: null,
      field: "tipoCambioId"
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "createdAt"
    },
    updatedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "updatedAt"
    },
    computer: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "computer"
    },
    username: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "username"
    },
    checksum: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "checksum"
    }
  }, {
    timestamps: false,
    freezeTableName: true,
});

const Nombres = sequelize.define("nombres", {
    nombreId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: true,
      autoIncrement: true,
      comment: null,
      field: "nombreId"
    },
    nombreBase: {
      type: DataTypes.STRING,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "nombreBase"
    },
    idiomaId: {
      type: DataTypes.INTEGER,
      allowNull: true,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "idiomaId",
      references: {
        key: "idiomaId",
        model: "idiomas_model"
      }
    },
    enabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: 0,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "enabled"
    }
  }, {
    timestamps: false,
    freezeTableName: true,
});

const ContratosProduccion = sequelize.define("contratosProduccion", {
      prodContratoId: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: true,
        autoIncrement: true,
        comment: null,
        field: "prodContratoId"
      },
      fechaInicio: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "fechaInicio"
      },
      fechaFin: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "fechaFin"
      },
      fechaFiniquitacion: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "fechaFiniquitacion"
      },
      enabled: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: 0,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "enabled"
      },
      periodicidad: {
        type: DataTypes.INTEGER,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "periodicidad"
      },
      createdAt: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "createdAt"
      },
      updatedAt: {
        type: DataTypes.DATE,
        allowNull: true,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "updatedAt"
      },
      computer: {
        type: DataTypes.STRING(20),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "computer"
      },
      username: {
        type: DataTypes.STRING(20),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "username"
      },
      checksum: {
        type: DataTypes.BLOB('tiny'),
        allowNull: false,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "checksum"
      },
      contEstadoId: {
        type: DataTypes.INTEGER,
        allowNull: true,
        defaultValue: null,
        primaryKey: false,
        autoIncrement: false,
        comment: null,
        field: "contEstadoId",
        references: {
          key: "contEstadoId",
          model: "estadosContratos_model"
        }
      }
    }, {
        timestamps: false,
        freezeTableName: true,
    });

const ItemsProductos = sequelize.define("itemsProductos", {
    itemProdId: {
      type: DataTypes.BIGINT,
      allowNull: false,
      defaultValue: null,
      primaryKey: true,
      autoIncrement: true,
      comment: null,
      field: "itemProdId"
    },
    canalId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "canalId",
      references: {
        key: "canalId",
        model: "canales_model"
      }
    },
    cantidadProductos: {
      type: DataTypes.DECIMAL,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "cantidadProductos"
    },
    montoTotal: {
      type: DataTypes.DECIMAL(19,4),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "montoTotal"
    },
    monedaId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "monedaId",
      references: {
        key: "monedaId",
        model: "monedas_model"
      }
    },
    fecha: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "fecha"
    },
    precioProductoId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "precioProductoId",
      references: {
        key: "precioProductoId",
        model: "preciosProductosContrato_model"
      }
    },
    enabled: {
      type: DataTypes.BOOLEAN,
      allowNull: false,
      defaultValue: 0,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "enabled"
    },
    createdAt: {
      type: DataTypes.DATE,
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "createdAt"
    },
    computer: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "computer"
    },
    username: {
      type: DataTypes.STRING(20),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "username"
    },
    checksum: {
      type: DataTypes.BLOB('tiny'),
      allowNull: false,
      defaultValue: null,
      primaryKey: false,
      autoIncrement: false,
      comment: null,
      field: "checksum"
    }
}, {
    timestamps: false,
    freezeTableName: true,
});

// Asociaciones para relaciones de foreign key.

LotesProduccionLogs.belongsTo(Productos, {sourceKey: 'productoId', foreignKey: 'productoId'});
Productos.hasMany(LotesProduccionLogs);

LotesProduccionLogs.belongsTo(PreciosProductosContrato, {sourceKey: 'prodContratoId', foreignKey: 'prodContratoId', targetKey: 'prodContratoId' });

PreciosProductosContrato.belongsTo(Productos, {sourceKey: 'productoId', foreignKey: "productoId"});
Productos.hasMany(PreciosProductosContrato);

PreciosProductosContrato.belongsTo(ContratosProduccion, {sourceKey: 'prodContratoId', foreignKey: "prodContratoId"});
ContratosProduccion.hasMany(PreciosProductosContrato);

Productos.hasOne(Nombres, {foreignKey: 'nombreId'});

LotesProduccionLogs.hasMany(ItemsProductos, {foreignKey: 'loteId'});

LotesProduccionLogs.belongsTo(TiposDeCambio, {as: 'costoMonedas', sourceKey: 'monedaId', foreignKey: 'monedaId', targetKey: 'monedaCambioId'});
PreciosProductosContrato.belongsTo(TiposDeCambio, {sourceKey: 'monedaId', foreignKey: 'monedaId', targetKey: 'monedaCambioId', as: 'precioMonedas' });
Productos.belongsTo(Nombres, {sourceKey: 'nombreId', foreignKey: 'nombreId' });


export class data_esencialORM {
    
    private static instance: data_esencialORM;
    private log: Logger;

    private constructor()
    {
        this.log = new Logger();
        try
        {
        } catch (e)
        {
            this.log.error(e);
        }
        // via singleton, accediendo a un solo pool tengo una conexiona la base de datos
    }

    public static getInstance() : data_esencialORM
    {
        if (!this.instance)
        {
            this.instance = new data_esencialORM();
        }
        return this.instance;
    }

    public async getLotes() : Promise<any>
    {
        //const results = await ItemsProductos.findAll();
        //console.log("All lotes:", JSON.stringify(results, null, 2));
        //console.log(JSON.stringify(results, null, 2));
       
        return new Promise<any>((resolve, reject) => {
            try {
                sequelize.authenticate();
                console.log('Connection has been established successfully.');
                const results = LotesProduccionLogs.findAll({
                    attributes: [
                        'loteId',
                        'fecha',
                        [sequelize.col('[producto->nombre].nombreBase'), 'productoNombre'],
                        'prodContratoId',
                        'plantaId',
                        [sequelize.literal('lotesProduccionLogs.cantidad - COALESCE(sum(itemsProductos.cantidadProductos), 0)'), 'cantidad'],
                        [sequelize.literal('lotesProduccionLogs.costoProduccion / costoMonedas.conversion'), 'costoProduccion'],
                        [sequelize.literal('preciosProductosContrato.precio / [preciosProductosContrato->precioMonedas].conversion'), 'precio'],
                    ],
                    include: [
                        {
                            model: ItemsProductos,
                            attributes: []
                        },
                        {
                            model: Productos,
                            required: true,
                            attributes: [],
                            include: [
                                {
                                    model: Nombres,
                                    required: true,
                                    attributes: [],
                                },
                            ],
                        },
                        {
                            model: TiposDeCambio,
                            required: true,
                            as: 'costoMonedas',
                            attributes: [],
                        },
                        {
                            model: PreciosProductosContrato,
                            required: true,
                            attributes: [],
                            where: {
                                'productoId': {
                                    [Op.eq]: sequelize.col('lotesProduccionLogs.productoId'),
                                }
                            },
                            include: [
                                {
                                    model: TiposDeCambio,
                                    required: true,
                                    as: 'precioMonedas',
                                    attributes: [],
                                },
                            ]
                        }
                    ],
                    order: [
                        ['precio', 'ASC'],
                        ['fecha', 'ASC']
                    ],
                    group: [
                        'lotesProduccionLogs.loteId',
                        'lotesProduccionLogs.fecha',
                        '[producto->nombre].nombreBase',
                        'lotesProduccionLogs.cantidad',
                        'lotesProduccionLogs.prodContratoId',
                        'lotesProduccionLogs.plantaId',
                        'lotesProduccionLogs.costoProduccion',
                        'costoMonedas.conversion',
                        'preciosProductosContrato.precio',
                        '[preciosProductosContrato->precioMonedas].conversion'
                    ],
                });
                resolve(results);
            } catch (error) {
                console.error('Unable to connect to the database:', error);
                reject(error);
            }
        })
    }
}

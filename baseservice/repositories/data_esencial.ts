import { Logger } from '../common'

const sql = require('mssql')

const sqlConfig = {
    user: "sa",
    password: "Twinsociety235",
    database: "ev34",
    server: "localhost",
    pool: {
      max: 5,
      min: 1,
      idleTimeoutMillis: 30000
    },
    options: {
      encrypt: true, 
      trustServerCertificate: true,
      requestTimeout: 60000
    }
}

export class data_esencial {
    private static instance: data_esencial;
    private log: Logger;

    private constructor()
    {
        this.log = new Logger();
        try
        {  
            sql.connect(sqlConfig);
        } catch (e)
        {
            this.log.error(e);
        }
        // via singleton, accediendo a un solo pool tengo una conexiona la base de datos
    }

    public static getInstance() : data_esencial
    {
        if (!this.instance)
        {
            this.instance = new data_esencial();
        }
        return this.instance;
    }

    public getLotes() : Promise<any>
    {
        return sql.connect(sqlConfig).then((pool:any) => {
            return pool.request()
                .execute("SP_getLotes")
        })
    }
}

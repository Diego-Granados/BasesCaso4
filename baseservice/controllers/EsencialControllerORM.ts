import { data_esencialORM } from '../repositories/data_esencialORM'
import { Logger } from '../common'


export class EsencialControllerORM {
    private static instance: EsencialControllerORM;
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
    }

    public static getInstance() : EsencialControllerORM
    {
        if (!this.instance)
        {
            this.instance = new EsencialControllerORM();
        }
        return this.instance;
    }

    public getLotes() : Promise<any> 
    {
        const esencialdata = data_esencialORM.getInstance();
        return esencialdata.getLotes();
    }

    /*
    public listArticles() : Promise<any> 
    {
        const dynamo = new articles_data();
        return dynamo.getAllArticles();
    }
    */
}
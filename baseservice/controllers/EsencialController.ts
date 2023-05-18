import { data_esencial } from '../repositories/data_esencial'
import { Logger } from '../common'


export class EsencialController {
    private static instance: EsencialController;
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

    public static getInstance() : EsencialController
    {
        if (!this.instance)
        {
            this.instance = new EsencialController();
        }
        return this.instance;
    }

    public getLotes() : Promise<any> 
    {
        const esencialdata = data_esencial.getInstance();
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
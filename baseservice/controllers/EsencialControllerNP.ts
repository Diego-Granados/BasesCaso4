import { data_esencialNP } from '../repositories/data_esencialNP'
import { Logger } from '../common'


export class EsencialControllerNP {
    private static instance: EsencialControllerNP;
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

    public static getInstance() : EsencialControllerNP
    {
        if (!this.instance)
        {
            this.instance = new EsencialControllerNP();
        }
        return this.instance;
    }
    
    public getLotes() : Promise<any> 
    {
        const esencialNPdata = data_esencialNP.getInstance();
        return esencialNPdata.getLotes();
    }

}
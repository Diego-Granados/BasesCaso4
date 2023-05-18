import * as express from 'express';
import { Logger } from '../common'
import { EsencialControllerNP } from '../controllers'

const app = express();
const log = new Logger();

app.get("/getLotes", (req, res, next) => {
    EsencialControllerNP.getInstance().getLotes()
    .then((data:any)=>{
        res.json(data);
    })
    .catch((err:any)=>{
        log.error(err);
        return "{msg: \"error\"}";
    });

});

export { app as esencialrouterNP };
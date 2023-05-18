import * as express from 'express';
import * as bodyParser from 'body-parser';
import { Logger } from '../common';
import {kindnessrouter} from './kindness';
import {articlesrouter} from './articlesrouter';
import { feriarouter } from './feriarouter';
import { esencialrouter } from './esencialrouter';
import { esencialrouterNP } from './esencialrouterNP';
import { esencialrouterORM } from './esencialrouterORM';

class Routes {

    public express: express.Application;
    public logger: Logger;

    constructor() {
        this.express = express();
        this.logger = new Logger();

        this.middleware();
        this.routes();
    }

    // Configure Express middleware.
    private middleware(): void {
        this.express.use(bodyParser.json());
        this.express.use(bodyParser.urlencoded({ extended: false }));
    }

    private routes(): void {
        this.express.use('/kind', kindnessrouter);
        this.express.use('/articles', articlesrouter);
        this.express.use('/feria', feriarouter);
        this.express.use('/esencial', esencialrouter);
        this.express.use('/esencialNP', esencialrouterNP);
        this.express.use('/esencialORM', esencialrouterORM);
        this.logger.info("Kindness route loaded");
        this.logger.info("articles route loaded");
        this.logger.info("feria route loaded");
        this.logger.info("esencial route loaded");
        this.logger.info("esencialNP route loaded");
        this.logger.info("esencialORM route loaded");
    }
}

export default new Routes().express;


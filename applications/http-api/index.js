const rascal = require('rascal');
const gracefulShutdown = require('http-graceful-shutdown');
const config = rascal.withDefaultConfig({
  vhosts: {
    '/': {
      connection: {
        hostname: process.env.AMQP_HOST,
        user: process.env.AMQP_USER,
        password: process.env.AMQP_PASSWORD
      },
      exchanges: {
        [process.env.AMQP_EXCHANGE]: {
          assert: true,
          check: true
        }
      },
      publications: {
        demo: {
          exchange: process.env.AMQP_EXCHANGE,
          routingKey: 'meetup'
        }
      }
    }
  }
});

const Koa = require('koa');
const Broker = rascal.BrokerAsPromised;

const { promisify } = require('util');
const crypto = require('crypto');

const pbkdf2Async = promisify(crypto.pbkdf2);
const randomBytesAsync = promisify(crypto.randomBytes);

(async () => {
  try {
    const broker = await Broker.create(config);
    broker.on('error', console.error);

    const app = new Koa();


    app.on('error', err => {
      console.error('server error', err)
    });

    // logger

    app.use(async (ctx, next) => {
      await next();
      const rt = ctx.response.get('X-Response-Time');
      console.log(`${ctx.method} ${ctx.url} - ${rt}`);
    });

    // x-response-time

    app.use(async (ctx, next) => {
      const start = Date.now();
      await next();
      const ms = Date.now() - start;
      ctx.set('X-Response-Time', `${ms}ms`);
    });

    app.use(async ctx => {
      const buf = await randomBytesAsync(256);
      const derivedKey = await pbkdf2Async('secret', buf, 500000, 64, 'sha512')
      const key = derivedKey.toString('hex')

      // Publish a message
      const publication = await broker.publish('demo', { msg: 'Hello Meetup!', key });
      publication.on('error', console.error);

      ctx.body = { msg: 'Hello Meetup!', key };
    });

    const server = app.listen(process.env.PORT, () => {
      console.log('Ready and waiting for requests.')
    });

    gracefulShutdown(server, {
      timeout: 20000,
      development: false,
      onShutdown: async () =>  {
        await broker.shutdown();
      }
    });
  } catch(err) {
    console.error(err);
    process.exit(1)
  }
})();

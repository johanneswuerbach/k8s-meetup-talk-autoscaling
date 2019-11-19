const rascal = require('rascal')
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
      queues: {
        meetup: {
          assert: true,
          check: true
        }
      },
      bindings: {
        meetup: {
          source: process.env.AMQP_EXCHANGE,
          destination: 'meetup'
        }
      },
      subscriptions: {
        demo: {
          prefetch: 1,
          queue: 'meetup'
        }
      }
    }
  }
});
const Broker = rascal.BrokerAsPromised;

(async () => {
  try {
    const broker = await Broker.create(config);
    broker.on('error', console.error);

    const cleanup = async () => {
      await broker.shutdown();
    }

    process.on('SIGTERM', cleanup)
    process.on('SIGINT', cleanup)

    // Consume a message
    const subscription = await broker.subscribe('demo');
    subscription.on('message', (message, content, ackOrNack) => {
      setTimeout(() => {
        console.log(content);
        ackOrNack();
      }, 2000)
    })
    subscription.on('error', console.error);

    console.log('Ready and waiting for messages.')
  } catch(err) {
    console.error(err);
    process.exit(1)
  }
})();

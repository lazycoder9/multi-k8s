const redis = require('redis');
const keys = require('./keys');

const redisClient = redis.createClient({
  host: keys.redisHost,
  port: keys.redisPort,
  retry_strategy: () => 1000,
});
const sub = redisClient.duplicate();

const fib = (index) => {
  console.log(`Calculating ${index}`);

  const iter = (count, a, b, c) => {
    if (count === 0) return a;
    return iter(count - 1, b, c, b + c);
  };
  return iter(index, 1, 1, 2);
};

sub.on('message', (channel, message) => {
  redisClient.hset('values', message, fib(parseInt(message)));
});
sub.subscribe('insert');

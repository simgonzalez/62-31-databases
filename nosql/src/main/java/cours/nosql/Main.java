package cours.nosql;

import cours.nosql.redis.Redis;
import redis.clients.jedis.Jedis;

import java.util.Map;

public class Main {
    public static void main(String[] args) {
        Redis.jedisExample();
    }
}
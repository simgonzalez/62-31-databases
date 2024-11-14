package cours.nosql.redis;

import redis.clients.jedis.Jedis;

import java.util.Map;

public abstract class Redis {
    public static void jedisExample() {
        try (Jedis jedis = new Jedis()) {
            jedis.mset("key1", "value1", "key2", "value2");
            jedis.mget("key1", "key2").forEach(System.out::println);
            jedis.hset("personn3#teo", Map.of("name", "Téo", "age", "25", "job", "dev", "sexe", "very big"));
            System.out.println(jedis.hget("personn3#teo", "name"));
            System.out.println(jedis.hgetAll("personn3#teo"));
            jedis.hgetAll("personn3#teo").forEach((k, v) -> System.out.println(k + " : " + v));
        } catch (Exception e) {
            System.out.println(e);
        }
    }
}

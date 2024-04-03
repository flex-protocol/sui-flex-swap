package org.test.suiswapexample.sui.contract.utils;

public class Pair<T1, T2> {
    private final T1 item1;
    private final T2 item2;

    public Pair(T1 item1, T2 item2) {
        this.item1 = item1;
        this.item2 = item2;
    }

    public T1 getItem1() {
        return item1;
    }

    public T2 getItem2() {
        return item2;
    }

    public static <T1, T2> Pair<T1, T2> of(T1 v1, T2 v2) {
        return new Pair<>(v1, v2);
    }
}

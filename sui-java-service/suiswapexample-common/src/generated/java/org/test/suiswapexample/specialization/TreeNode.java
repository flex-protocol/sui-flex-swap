package org.test.suiswapexample.specialization;

public interface TreeNode<T> {
    T getContent();

    Iterable<TreeNode<T>> getChildren();
}

// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.sellpool;

import java.util.Map;
import java.util.List;
import org.dddml.support.criterion.Criterion;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;

public interface SellPoolStateQueryRepository {
    SellPoolState get(String id);

    Iterable<SellPoolState> getAll(Integer firstResult, Integer maxResults);
    
    Iterable<SellPoolState> get(Iterable<Map.Entry<String, Object>> filter, List<String> orders, Integer firstResult, Integer maxResults);

    Iterable<SellPoolState> get(Criterion filter, List<String> orders, Integer firstResult, Integer maxResults);

    SellPoolState getFirst(Iterable<Map.Entry<String, Object>> filter, List<String> orders);

    SellPoolState getFirst(Map.Entry<String, Object> keyValue, List<String> orders);

    Iterable<SellPoolState> getByProperty(String propertyName, Object propertyValue, List<String> orders, Integer firstResult, Integer maxResults);

    long getCount(Iterable<Map.Entry<String, Object>> filter);

    long getCount(Criterion filter);

}


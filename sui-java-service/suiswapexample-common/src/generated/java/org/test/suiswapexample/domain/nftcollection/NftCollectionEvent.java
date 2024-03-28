// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.nftcollection;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.specialization.Event;

public interface NftCollectionEvent extends Event, SuiEventEnvelope, SuiMoveEvent, HasStatus {

    interface SqlNftCollectionEvent extends NftCollectionEvent {
        NftCollectionEventId getNftCollectionEventId();

        boolean getEventReadOnly();

        void setEventReadOnly(boolean readOnly);
    }

    String getCollectionType();

    //void setCollectionType(String collectionType);

    BigInteger getVersion();
    
    //void setVersion(BigInteger version);

    String getId_();
    
    //void setId_(String id);

    String getCreatedBy();

    void setCreatedBy(String createdBy);

    Date getCreatedAt();

    void setCreatedAt(Date createdAt);

    String getCommandId();

    void setCommandId(String commandId);


}


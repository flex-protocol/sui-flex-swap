// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.nftcollection;

import java.util.*;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.AbstractCommand;

public abstract class AbstractNftCollectionSubtypeCommand extends AbstractCommand implements NftCollectionSubtypeCommand {

    private String subtypeValue;

    public String getSubtypeValue()
    {
        return this.subtypeValue;
    }

    public void setSubtypeValue(String subtypeValue)
    {
        this.subtypeValue = subtypeValue;
    }

    private String nftCollectionCollectionType;

    public String getNftCollectionCollectionType()
    {
        return this.nftCollectionCollectionType;
    }

    public void setNftCollectionCollectionType(String nftCollectionCollectionType)
    {
        this.nftCollectionCollectionType = nftCollectionCollectionType;
    }


}


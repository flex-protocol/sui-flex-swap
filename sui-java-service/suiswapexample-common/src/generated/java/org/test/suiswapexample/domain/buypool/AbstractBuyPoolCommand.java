// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.buypool;

import java.util.*;
import java.math.BigInteger;
import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.AbstractCommand;

public abstract class AbstractBuyPoolCommand extends AbstractCommand implements BuyPoolCommand {

    private String id;

    public String getId()
    {
        return this.id;
    }

    public void setId(String id)
    {
        this.id = id;
    }

    private Long offChainVersion;

    public Long getOffChainVersion()
    {
        return this.offChainVersion;
    }

    public void setOffChainVersion(Long offChainVersion)
    {
        this.offChainVersion = offChainVersion;
    }


}


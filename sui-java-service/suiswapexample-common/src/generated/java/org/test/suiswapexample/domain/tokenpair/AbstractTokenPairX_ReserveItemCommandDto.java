// <autogenerated>
//   This file was generated by dddappp code generator.
//   Any changes made to this file manually will be lost next time the file is regenerated.
// </autogenerated>

package org.test.suiswapexample.domain.tokenpair;

import java.util.Date;
import org.test.suiswapexample.domain.*;
import org.test.suiswapexample.domain.AbstractCommand;

public abstract class AbstractTokenPairX_ReserveItemCommandDto extends AbstractCommand {

    /**
     * Key
     */
    private String key;

    public String getKey()
    {
        return this.key;
    }

    public void setKey(String key)
    {
        this.key = key;
    }


    public void copyTo(TokenPairX_ReserveItemCommand command) {
        command.setKey(this.getKey());
        
        command.setRequesterId(this.getRequesterId());
        command.setCommandId(this.getCommandId());
    }

}

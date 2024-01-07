package org.test.suiswapexample;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;
import org.test.suiswapexample.specialization.ApplicationContext;
import org.test.suiswapexample.specialization.spring.SpringApplicationContext;

@Component
public class ApplicationContextProvider implements ApplicationContextAware {
    @Override
    public void setApplicationContext(org.springframework.context.ApplicationContext ctx) throws BeansException {
        ApplicationContext.current = new SpringApplicationContext(ctx);
    }
}

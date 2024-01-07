package org.test.suiswapexample.sui.contract.repository;

import org.test.suiswapexample.sui.contract.SuiPackage;
import org.springframework.data.jpa.repository.JpaRepository;

public interface SuiPackageRepository extends JpaRepository<SuiPackage, String> {
    
}

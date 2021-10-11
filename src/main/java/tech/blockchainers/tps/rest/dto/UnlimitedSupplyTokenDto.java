package tech.blockchainers.tps.rest.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigInteger;

@Data
@Builder
public class UnlimitedSupplyTokenDto {

    private String address;
    private BigInteger allowance;

}

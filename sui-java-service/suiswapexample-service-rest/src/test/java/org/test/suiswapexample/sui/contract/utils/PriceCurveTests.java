package org.test.suiswapexample.sui.contract.utils;

import org.junit.jupiter.api.Test;

import java.math.BigInteger;

import static org.test.suiswapexample.sui.contract.utils.PriceCurve.*;

public class PriceCurveTests {

    /*
    #[test]
    public fun test_price_curve_1() {
        //
        // curve_type: u8,
        // x_amount: u64,
        // price_delta_x_amount: u64,
        // spot_price: u64,
        // price_delta_numerator: u64,
        // price_delta_denominator: u64
        //
        let curve_type = price_curve::linear_curve();
        let x_amount = 50;
        let price_delta_x_amount = 100;
        //
        // 10% increase in price for each one sold
        //
        let spot_price = 1_000_000;
        let start_price = 1_000_000;
        debug::print(&start_price);
        let price_delta_numerator = 100_000;
        let price_delta_denominator = 1_000_000;
        let (y_amount, new_spot_price) = price_curve::get_buy_info(
            curve_type,
            x_amount,
            price_delta_x_amount,
            spot_price,
            start_price,
            price_delta_numerator,
            price_delta_denominator
        );

        debug::print(&y_amount);
        debug::print(&new_spot_price);
        //[debug] 512499
        //[debug] 1049999

        spot_price = new_spot_price;
        let (y_amount, new_spot_price) = price_curve::get_sell_info(
            curve_type,
            x_amount,
            price_delta_x_amount,
            spot_price,
            start_price,
            price_delta_numerator,
            price_delta_denominator
        );
        debug::print(&y_amount);
        debug::print(&new_spot_price);
    }
     */
    @Test
    public void test_price_curve_1() {
        byte curve_type = LINEAR_CURVE;
        BigInteger x_amount = BigInteger.valueOf(50);
        BigInteger price_delta_x_amount = BigInteger.valueOf(100);
        BigInteger spot_price = BigInteger.valueOf(1_000_000);
        BigInteger start_price = BigInteger.valueOf(1_000_000);
        BigInteger price_delta_numerator = BigInteger.valueOf(100_000);
        BigInteger price_delta_denominator = BigInteger.valueOf(1_000_000);
        Pair<BigInteger, BigInteger> buyInfo = getBuyInfo(
                curve_type,
                x_amount,
                price_delta_x_amount,
                spot_price,
                start_price,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(buyInfo.getItem1());
        System.out.println(buyInfo.getItem2());

        spot_price = buyInfo.getItem2();
        Pair<BigInteger, BigInteger> sellInfo = getSellInfo(
                curve_type,
                x_amount,
                price_delta_x_amount,
                spot_price,
                start_price,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(sellInfo.getItem1());
        System.out.println(sellInfo.getItem2());
    }

    /*
    #[test]
    public fun test_price_curve_2() {
        //
        // Let's assume the following:
        //
        // * each NFT has the same value;
        // * the results returned by "nft_service::get_amount()",
        //   the "exchange_rate_denominator", and "price_delta_x_amount" of "SellPool" are all fixed to 1.
        //
        // Let us calculate the y_amount needed to buy 2 NFTs.
        //
        let price_curve_type = price_curve::linear_curve();
        let x_amount = 2; //x_amount: u64,
        let price_delta_x_amount = 1; //price_delta_x_amount: u64,
        let exchange_rate_numerator = 10_000_000; //spot_price: u64,
        //let exchange_rate_denominator = 1;
        //
        // 10% increase in price for each one sold
        //
        let price_delta_numerator = 10;
        let price_delta_denominator = 100;

        let start_exchange_rate_numerator = exchange_rate_numerator;
        debug::print(&start_exchange_rate_numerator);
        let (y_amount_required_numerator, new_exchange_rate_numerator) = price_curve::get_buy_info(
            price_curve_type,
            x_amount, // <- x_amount: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        let y_amount_required = y_amount_required_numerator;
        debug::print(&y_amount_required);
        debug::print(&new_exchange_rate_numerator);
        //let y_amount_in = 23000;
        //assert!(y_amount_in >= y_amount_required, 1);

        exchange_rate_numerator = new_exchange_rate_numerator; //<- spot_price: u64,
        let (y_amount, new_spot_price) = price_curve::get_sell_info(
            price_curve_type,
            x_amount, // <- x_amount: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        debug::print(&y_amount);
        debug::print(&new_spot_price);
    }
     */
    @Test
    public void test_price_curve_2() {
        byte price_curve_type = LINEAR_CURVE;
        BigInteger x_amount = BigInteger.valueOf(2);
        BigInteger price_delta_x_amount = BigInteger.valueOf(1);
        BigInteger exchange_rate_numerator = BigInteger.valueOf(10_000_000);
        BigInteger price_delta_numerator = BigInteger.valueOf(10);
        BigInteger price_delta_denominator = BigInteger.valueOf(100);
        BigInteger start_exchange_rate_numerator = exchange_rate_numerator;
        System.out.println(start_exchange_rate_numerator);
        Pair<BigInteger, BigInteger> buyInfo = getBuyInfo(
                price_curve_type,
                x_amount,
                price_delta_x_amount,
                exchange_rate_numerator,
                start_exchange_rate_numerator,
                price_delta_numerator,
                price_delta_denominator
        );
        BigInteger y_amount_required = buyInfo.getItem1();
        System.out.println(y_amount_required);
        System.out.println(buyInfo.getItem2());

        exchange_rate_numerator = buyInfo.getItem2();
        Pair<BigInteger, BigInteger> sellInfo = getSellInfo(
                price_curve_type,
                x_amount,
                price_delta_x_amount,
                exchange_rate_numerator,
                start_exchange_rate_numerator,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(sellInfo.getItem1());
        System.out.println(sellInfo.getItem2());
    }

    /*

    #[test]
    public fun test_price_curve_3() {
        //
        // curve_type: u8,
        // x_amount: u64,
        // price_delta_x_amount: u64,
        // spot_price: u64,
        // price_delta_numerator: u64,
        // price_delta_denominator: u64
        //
        let curve_type = price_curve::exponential_curve();
        let x_amount = 250;
        let price_delta_x_amount = 100;
        //
        // 10% increase in price for each one sold
        //
        let spot_price = 1_000_000_000;
        let start_price = spot_price;
        debug::print(&start_price);
        let price_delta_numerator = 100_000;
        let price_delta_denominator = 1_000_000;
        let (y_amount, new_spot_price) = price_curve::get_buy_info(
            curve_type,
            x_amount,
            price_delta_x_amount,
            spot_price,
            start_price,
            price_delta_numerator,
            price_delta_denominator
        );
        //1270499998
        //1264450000
        debug::print(&y_amount);
        debug::print(&new_spot_price);

        spot_price = new_spot_price;
        //x_amount = 50;
        let (y_amount, new_spot_price) = price_curve::get_sell_info(
            curve_type,
            x_amount,
            price_delta_x_amount,
            spot_price,
            start_price,
            price_delta_numerator,
            price_delta_denominator
        );
        debug::print(&y_amount);
        debug::print(&new_spot_price);
    }
     */
    @Test
    public void test_price_curve_3() {
        byte curve_type = EXPONENTIAL_CURVE;
        BigInteger x_amount = BigInteger.valueOf(250);
        BigInteger price_delta_x_amount = BigInteger.valueOf(100);
        BigInteger spot_price = BigInteger.valueOf(1_000_000_000);
        BigInteger start_price = spot_price;
        System.out.println(start_price);
        BigInteger price_delta_numerator = BigInteger.valueOf(100_000);
        BigInteger price_delta_denominator = BigInteger.valueOf(1_000_000);
        Pair<BigInteger, BigInteger> buyInfo = getBuyInfo(
                curve_type,
                x_amount,
                price_delta_x_amount,
                spot_price,
                start_price,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(buyInfo.getItem1());
        System.out.println(buyInfo.getItem2());

        spot_price = buyInfo.getItem2();
        Pair<BigInteger, BigInteger> sellInfo = getSellInfo(
                curve_type,
                x_amount,
                price_delta_x_amount,
                spot_price,
                start_price,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(sellInfo.getItem1());
        System.out.println(sellInfo.getItem2());
    }

    /*


    #[test]
    public fun test_price_curve_4() {
        //
        // Let's assume the following:
        //
        // * each NFT has the same value;
        // * the results returned by "nft_service::get_amount()",
        //   the "exchange_rate_denominator", and "price_delta_x_amount" of "SellPool" are all fixed to 1.
        //
        // Let us calculate the y_amount needed to buy 2 NFTs.
        //
        let price_curve_type = price_curve::exponential_curve();
        let x_amount = 2; //x_amount: u64,
        let price_delta_x_amount = 1; //price_delta_x_amount: u64,
        let exchange_rate_numerator = 10_000_000; //spot_price: u64,
        //let exchange_rate_denominator = 1;
        //
        // 10% increase in price for each one sold
        //
        let price_delta_numerator = 10;
        let price_delta_denominator = 100;

        let start_exchange_rate_numerator = exchange_rate_numerator;
        debug::print(&start_exchange_rate_numerator);
        let (y_amount_required_numerator, new_exchange_rate_numerator) = price_curve::get_buy_info(
            price_curve_type,
            x_amount, // <- x_amount: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        let y_amount_required = y_amount_required_numerator;
        debug::print(&y_amount_required);
        debug::print(&new_exchange_rate_numerator);
        //let y_amount_in = 23_100_000;
        //assert!(y_amount_in >= y_amount_required, 1);

        exchange_rate_numerator = new_exchange_rate_numerator; //<- spot_price: u64,
        let (y_amount, new_spot_price) = price_curve::get_sell_info(
            price_curve_type,
            x_amount, // <- x_amount: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );
        debug::print(&y_amount);
        debug::print(&new_spot_price);
    }
     */
    @Test
    public void test_price_curve_4() {
        byte price_curve_type = EXPONENTIAL_CURVE;
        BigInteger x_amount = BigInteger.valueOf(2);
        BigInteger price_delta_x_amount = BigInteger.valueOf(1);
        BigInteger exchange_rate_numerator = BigInteger.valueOf(10_000_000);
        BigInteger price_delta_numerator = BigInteger.valueOf(10);
        BigInteger price_delta_denominator = BigInteger.valueOf(100);
        BigInteger start_exchange_rate_numerator = exchange_rate_numerator;
        System.out.println(start_exchange_rate_numerator);
        Pair<BigInteger, BigInteger> buyInfo = getBuyInfo(
                price_curve_type,
                x_amount,
                price_delta_x_amount,
                exchange_rate_numerator,
                start_exchange_rate_numerator,
                price_delta_numerator,
                price_delta_denominator
        );
        BigInteger y_amount_required = buyInfo.getItem1();
        System.out.println(y_amount_required);
        System.out.println(buyInfo.getItem2());

        exchange_rate_numerator = buyInfo.getItem2();
        Pair<BigInteger, BigInteger> sellInfo = getSellInfo(
                price_curve_type,
                x_amount,
                price_delta_x_amount,
                exchange_rate_numerator,
                start_exchange_rate_numerator,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(sellInfo.getItem1());
        System.out.println(sellInfo.getItem2());
    }

    /*
    #[test]
    public fun test_price_curve_5() {
        let price_curve_type = 0;
        let x_amount = 500;
        let price_delta_x_amount = 500;
        let exchange_rate_numerator = 11110;
        let exchange_rate_denominator = 100;
        let start_exchange_rate_numerator = exchange_rate_numerator;
        debug::print(&start_exchange_rate_numerator);
        let price_delta_numerator = 10;
        let price_delta_denominator = 100;
        let (y_amount_out_numerator, new_exchange_rate_numerator) = price_curve::get_sell_info(
            price_curve_type,
            x_amount, // <- x_amount: u64,
            price_delta_x_amount,
            exchange_rate_numerator,
            start_exchange_rate_numerator,
            price_delta_numerator,
            price_delta_denominator,
        );

        debug::print(&(y_amount_out_numerator / exchange_rate_denominator));
        debug::print(&new_exchange_rate_numerator);
    }
     */
    @Test
    public void test_price_curve_5() {
        byte price_curve_type = 0;
        BigInteger x_amount = BigInteger.valueOf(500);
        BigInteger price_delta_x_amount = BigInteger.valueOf(500);
        BigInteger exchange_rate_numerator = BigInteger.valueOf(11110);
        BigInteger exchange_rate_denominator = BigInteger.valueOf(100);
        BigInteger start_exchange_rate_numerator = exchange_rate_numerator;
        System.out.println(start_exchange_rate_numerator);
        BigInteger price_delta_numerator = BigInteger.valueOf(10);
        BigInteger price_delta_denominator = BigInteger.valueOf(100);
        Pair<BigInteger, BigInteger> sellInfo = getSellInfo(
                price_curve_type,
                x_amount,
                price_delta_x_amount,
                exchange_rate_numerator,
                start_exchange_rate_numerator,
                price_delta_numerator,
                price_delta_denominator
        );
        System.out.println(sellInfo.getItem1().divide(exchange_rate_denominator));
        System.out.println(sellInfo.getItem2());
    }
}

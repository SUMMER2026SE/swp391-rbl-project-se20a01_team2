package util;

/**
 * VNPay payment gateway configuration constants.
 * All credentials are for the SANDBOX (test) environment.
 */
public final class VNPayConfig {

    private VNPayConfig() {}

    /** Merchant code (vnp_TmnCode) */
    public static final String TMN_CODE    = "O5V95OY4";

    /** Secret key for HMAC-SHA512 checksum */
    public static final String HASH_SECRET = "PY9GVFBZI6J7250NWPLEFZIJEKDT05QG";

    /** VNPay sandbox payment endpoint */
    public static final String PAY_URL     = "https://sandbox.vnpayment.vn/paymentv2/vpcpay.html";

    /** API version */
    public static final String VERSION     = "2.1.0";

    /** Command for standard payment */
    public static final String COMMAND     = "pay";

    /** Currency (VND only) */
    public static final String CURR_CODE   = "VND";

    /** Display language: vn or en */
    public static final String LOCALE      = "vn";

    /** Order category per VNPay specification */
    public static final String ORDER_TYPE  = "other";

    /** Payment link validity window (minutes) */
    public static final int    EXPIRE_MINUTES = 15;
}

public with sharing class CTPersonController {
    public static String getToken(String mobileNo){
        Blob value = Blob.valueOf(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);

        // GET THE STRING VALUE OF HASH BLOB
        return EncodingUtil.base64Encode(hash);
    }
    
}
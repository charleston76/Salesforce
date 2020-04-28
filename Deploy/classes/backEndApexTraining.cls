public with sharing class backEndApexTraining {
    public backEndApexTraining() {

    }
    public static List<Account> getReturnAccount(String intLimit ){
        List<Account> objAcount = new List<Account>();

        objAcount = [ SELECT ID, NAME
                        from Account];

        return objAcount;
    }
}

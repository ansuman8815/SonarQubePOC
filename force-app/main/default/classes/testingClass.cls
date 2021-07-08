Public class testingClass{
    String s = 'initial value';
    public String method1(){
        method2();
        return s;
    }
    public void method2(){
        s = 'method2 updated the value';
    }

}
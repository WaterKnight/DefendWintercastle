//typeDefinitions.lua

#include <cmath>
#include <fstream>
#include <iostream>
#include <vector>
#include <string>

//using namespace std;

char* readFromInputString(int a, int b){
    return "a";
}

vector<char*> v;

void writeToTmp(char* val){
    v.push_back(val);
}

string ntype(char* val){
    return "string";
}

char NULL_CHAR_VAL = (char)0;
char* NULL_CHAR = &NULL_CHAR_VAL;

class charType{
    public:
        static char* defVal;
        static valType me;
    
        static char* setFunc(char* val){
    	    if (ntype(val) != "string")
    		    return defVal;
    
    	    return val;
        };
    
        static char* readFunc(){
            char* result = readFromInputString(0, 0);
    
            if (&result == NULL)
    		    return NULL_CHAR;
    
      		return result;
        };
    
    	static void writer(char* val){
            writeToTmp(val);
        };
        
        static void init(){
            me.readFunc = readFunc;
            me.setFunc = setFunc;
            me.writeFunc = writer;
        }
};

char* charType::defVal = NULL_CHAR;
valType charType::me = valType("char", 1, string(NULL_CHAR));

/*int main(){
    ofstream myFile("test.txt", ofstream::out|ofstream::binary);

printf("finished");
    system("pause");
    
    valType* t_ptr = &charType::me;
    
printf("%i\t%i", t_ptr, &charType::me);
    charType::init();
    
    system("pause");
    
    valType t = *t_ptr;
    
    t.writeFunc("A");
    t.writeFunc(NULL_CHAR);
    t.writeFunc("def");
    t.writeFunc("ghighi");
    
    for (int i=0; i < v.size(); i++){
        myFile.write(v.at(i), max(size_t(1), strlen(v.at(i))));
    };
    
    myFile.close();
    
    system("pause");

    return EXIT_SUCCESS;
}*/

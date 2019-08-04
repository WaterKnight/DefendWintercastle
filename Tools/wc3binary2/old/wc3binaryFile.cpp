

#include <cmath>
#include <string>
#include <vector>

using namespace std;

int pow2(int exp){
    return (int)pow((float)2, (float)exp);
}

bool byteHasBit(char* num, int bit){
    int f = (int)(floor(*num / pow2(bit - 1)));

    return ((f % 2) == 1);
}

int byteGetBit(char* num, int bit){
    if (byteHasBit(num, bit)){
        return 1;
    }
    
    return 0;
}

void byteEraseBit2(char* num, int bit){
    if (byteHasBit(num, bit)){
        *num = *num - pow2(bit - 1);
    }
}

void byteEraseBit(char* num, int bit){
    *num = *num & ~pow2(bit - 1);
}

void byteAddBit2(char* num, int bit){
    if (byteHasBit(num, bit)){
        return;
    }
    
    *num = *num + pow2(bit - 1);
}

void byteAddBit(char* num, int bit){            
    *num = *num | pow2(bit - 1);
}

char byteSetBit(char* num, int bit, int val){
    if (val != 0){
        byteAddBit(num, bit);
    }

    byteEraseBit(num, bit);
}

template <class T> class dict{
    vector<const char*>* keys;
    vector<T>* vals;

    public:
        T get(const char* name){
            for (int i = 0; i < keys->size(); i++){
                if (strcmp(name, keys->at(i)) == 0){
                    return vals->at(i);
                }
            }
            
            return NULL;
        }
        
        void add(const char* key, T val){
            keys->push_back(key);
            vals->push_back(val);
        }
        
        void clear(){
            keys->clear();
            vals->clear();
        }
        
        dict(){
            keys = new vector<const char*>;
            vals = new vector<T>;
        }
};

class wc3binaryFile{
    public:
        class mode{
            public:
                string name;
                
                static int abc;
                
                mode(string nameArg){
                    name = nameArg;
                }
        };

        static mode MODE_READING;
        static mode MODE_WRITING;
        
        mode curMode;
        
        class node{
            const char* name;
            node* parent;
            vector<node*>* subs;
            dict<node*>* subsByName;

            public:
                string getFullPath(){
                    string result = string(name);
                    node* parent2 = parent;
                    
                    while (parent2 != NULL){
                        result.insert(0, "\\");
                        result.insert(0, parent2->name);

                        parent2 = parent2->parent;
                    };
                    
                    return result;
                }
                
                void clear(){
                    subs->clear();
                    subsByName->clear();
                }
                
                void print(int nestDepth){
                    for (int i = 0; i < subs->size(); i++){
                        printf("\n", nestDepth);
                        printf("%s", string(nestDepth, '\t').c_str());
                        printf("%s", subs->at(i)->name);
                        subs->at(i)->print(nestDepth + 1);
                    }
                }
                
                void print(){
                    printf("printing %s", getFullPath().c_str());
                    
                    print(1);
                }
                
                bool e(bool cond){
                    if (!cond){
                        printf("already exists");
                        system("pause");
                        
                        return false;
                    }
                    
                    return true;
                }
                
                node(node* parentArg, const char* nameArg){
                    if (parentArg != NULL){
                        bool cond = (parentArg->subsByName->get(nameArg) == NULL);
                        assert(e(cond));
                    }

                    name = nameArg;
                    parent = parentArg;
                    subs = new vector<node*>;
                    subsByName = new dict<node*>;
                    
                    if (parent != NULL){
                        parent->subs->push_back(this);
                        parent->subsByName->add(name, this);
                    }
                }
        };
};

class valType{
    public:
        static vector<valType*> all;
        static dict<valType*> allByName;
        
        string defVal;
        string name;
        int size;

        void (*writeFunc)(char*);
        char* (*setFunc)(char*);
        char* (*readFunc)();

        static valType* getByName(const char* name){            
            return allByName.get(name);
        }

        valType(string nameArg, int sizeArg, string defValArg){
            defVal = defValArg;
            name = nameArg;
            size = sizeArg;
            
            all.push_back(this);
            allByName.add(name.c_str(), this);
        };
};

vector<valType*> valType::all = vector<valType*>();
dict<valType*> valType::allByName = dict<valType*>();

#include "typeDefinitionsC.cpp"

wc3binaryFile::mode wc3binaryFile::MODE_READING = wc3binaryFile::mode("reading");
wc3binaryFile::mode wc3binaryFile::MODE_WRITING = wc3binaryFile::mode("writing");

int main(){
    valType* t = valType::getByName("char");
    
    if (t != NULL){
        printf("%s", t->name.c_str());
    }

    wc3binaryFile::node* first = new wc3binaryFile::node(NULL, "first");
    wc3binaryFile::node* second = new wc3binaryFile::node(first, "second");
    wc3binaryFile::node* second2 = new wc3binaryFile::node(first, "second");
        wc3binaryFile::node* third = new wc3binaryFile::node(second, "third");
        wc3binaryFile::node* fourth = new wc3binaryFile::node(first, "fourth");
    
    first->print();
    
    char c=15;
    
    byteAddBit(&c, 6);
    byteEraseBit(&c, 6);
    
    printf("\n\n%i", c);
    
    //printf("%s", t.name.c_str());
    printf("finished");
    system("pause");
    return EXIT_SUCCESS;
}

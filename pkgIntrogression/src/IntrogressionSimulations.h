#ifndef GLOBALSTRUCT_H
#define GLOBALSTRUCT_H

#include <mutex>
#include <atomic>
#include <vector>
#include <boost/dynamic_bitset.hpp>
#include <Rcpp.h>
#include "random.h"

struct Parameters{
    Parameters(){};
    Parameters(const Rcpp::List &);
    #ifdef CSVFUNCTION_H
        Parameters(int argc, char *argv[]);    
    #endif

    void Initialize();
    
    double RECOMBINATIONRATE;
    double MUTATIONRATE = 0.0   ;
    double INTRINSIC_GROWTHRATE;
    int NGEN;
    int NLOCI;
    int DISTLOCAL;
    int NPLOIDY;
    int NREP;
    int NINIT[2];
    int K;
    double SC_MAJOR;
    double SC_LOCAL;
    int NLOCAL_ADAPTED_LOCI;

    std::vector<double> SC_GENOME;
    std::vector<int> index;
    std::vector<boost::dynamic_bitset<>> INIT_GENOME[2];
    boost::dynamic_bitset<> r_global, m_global;
};

struct DataBlock{
    public:
    std::vector<int> popsize;
    std::vector<std::vector<int>> allele0;
    std::vector<std::vector<int>> allele1;
    std::vector<int> major0;
    std::vector<int> major1;
    std::vector<double> introgressed0;
    std::vector<double> introgressed1;
};

struct SimData{  
    SimData(){nofixcounter = 0;}
    void push_back_protect(DataBlock* &datablock){
        mu_datablock.lock();
        DataSet.push_back(datablock);
        mu_datablock.unlock();
    };

    std::mutex mu_datablock;
    std::vector<DataBlock*> DataSet;
    std::atomic<int> nofixcounter;
};

bool RunSimulation(const Parameters &SimPars, SimData &SimulationData);

#endif

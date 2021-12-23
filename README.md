

# 프로젝트 목표
Deep Neural Networks (DNNs) 를 가속하기 위해 많은 NPU 들이 나오고 있습니다. 하지만 NPU를 개발 할 때 성능저하가 온다면 deep learning workload는 실행시간이 매우 길다는 특성 때문에 그 원인을 파악하기 쉽지 않습니다. 이번 프로젝트에서는 firesim 의 debugging 툴 중 하나인 FPGA printf 를 이용하여 deep learning workload 성능저하 원인을 쉽게 파악할 수 있게 해줍니다.


# 프로젝트 환경설정

### firesim 기본 환경설정 
* firesim 환경 설정을 처음부터 하려면 약 6시간 정도 걸립니다. 기본 설정 방법은 firesim documentation - https://docs.fires.im/en/latest/Initial-Setup/index.html 을 참조하시기 바랍니다.
* 좀 더 빠른 환경 셋업을 원하시면 수업 계정에서 만든 ami 이미지 firesim-setup-v0.4 를 이용하거나 Launch template(firesim-fast-setup) 을 이용하시면 됩니다.
* 지금부터는 firesim documentation을 참고했거나, 저희가 미리 만들어놓은 인스턴스 이미지를 이용하여 기본적인 설정이 완료되었다고 가정하고 이후 환경설정 방법에 대해 설명하겠습니다.

### 인증키   
* Firesim 은 시뮬레이션 자동화를 위해 F1인스턴스를 자동적으로 생성하고 종료합니다. 하지만 이러한 자동화를 위해서 인스턴스 접속 키를 반드시 firesim.pem 으로 설정해야합니다.
* 보안상의 이유로 firesim.pem 키는 프로젝트 토론방에서 확인할 수 있습니다.

### git repository setup
프로젝트를 문제없이 구동하기 위해선 기본 설정되어 있는 chipyard git repository 중 총 세개를 변경해야 합니다. 다음과 같은 명령어를 실행하면 모든 git repository 설정이 완료됩니다.
``` Shell
  #!/bin/bash 
  cd firesim/target-design/chipyard/
  git reset --hard
  git remote remove origin
  git remote add origin https://github.com/thuako/soc-design-methodology-chipyard
  
  git pull origin soc-chipyard-base
  git checkout -t origin/soc-chipyard-base
  source scripts/soc-methology-setup.sh
```

# 시뮬레이션 방법

### ResNet50 바이너리 선택
프로젝트에서는 총 세개의 ResNet50 바이너리를 제공하고 있습니다 (loop, basic, double). 시뮬레이션 하기 원하는 바이너리를 설정하기 위해서는
``` Shell
  cd $custommarshal
  vim soc-marshal-sim.yaml
```
위와 같은 명령어를 통해 soc-marshal-sim.yaml 파일을 열고 10번째 줄을 수정합니다.
``` Shell
# target-binary에 loop, basic, double 중 하나를 입력
   "command": "/run-simulate.sh <target-binary> ", 
```


### FPGA disk setup
타겟 바이너리를 선택하였으면 FPGA에 올릴 디스크 파일을 만듭니다.

``` Shell
  cd $custommarshal

  # 이전에 디스크 파일을 만든적이 있다면 해당 명령어도 같이 실행
  # marshal clean custom-marshal/soc-gemmini-sim.yaml
  marshal build custom-marshal/soc-gemmini-sim.yaml
  marshal install custom-marshal/soc-gemmini-sim.yaml  
```

그리고 아래 파일을 들어가 4번재 줄에 "synthe*"를 추가합니다.
``` Shell
  vim /home/centos/firesim/deploy/workloads/soc-gemmini-sim.json

  3   "common_simulation_outputs": [
  4     "uartlog", "synthe*"
  5   ],
```

### Run FPGA simulation
이제 시뮬레이션을 돌리기 위한 모든 준비가 완료되었습니다. 다음과 같은 스크립트를 실행하여 시뮬레이션을 시작합니다. 시뮬레이션은 약 15분 정도 진행됩니다.
``` Shell
  cd $soc_firesim
  ./scripts/sim-all.sh
```
### Simulation Result

시뮬레이션결과는 
~/firesim/deploy/result-workload/####-##-##--##-##-##-soc-gemmini-sim/soc-gemmini-sim-baseline/ 에서 확인 가능합니다.
시뮬레이션 결과 파일은 총 3개가 있습니다. result.log는 타겟 바이너리를 실행할 때 리눅스 터미널에서 출력해주는 결과이고, synthesized-prints.out0 는 firesim printf 를 통해 출력한 sram 내부의 정보입니다. uartlog 는 시뮬레이션 처음부터 끝까지 모든 터미널 output을 기록한 로그입니다.

# Sram State Visulization
sram 내부 정보를 layer별, cycle 별로 나누어 sram 상황을 볼 수 있는 방법은
``` Shell
  cd $softwaregemmini
  cd print_vis
```
위와 같은 디렉토리로 들어가 jupyter notebook 을 실행하여 확인 할 수 있습니다.















------------------------

![CHIPYARD](https://github.com/ucb-bar/chipyard/raw/master/docs/_static/images/chipyard-logo-full.png)

# Chipyard Framework [![CircleCI](https://circleci.com/gh/ucb-bar/chipyard/tree/master.svg?style=svg)](https://circleci.com/gh/ucb-bar/chipyard/tree/master)

## Using Chipyard

To get started using Chipyard, see the documentation on the Chipyard documentation site: https://chipyard.readthedocs.io/

## What is Chipyard

Chipyard is an open source framework for agile development of Chisel-based systems-on-chip.
It will allow you to leverage the Chisel HDL, Rocket Chip SoC generator, and other [Berkeley][berkeley] projects to produce a [RISC-V][riscv] SoC with everything from MMIO-mapped peripherals to custom accelerators.
Chipyard contains processor cores ([Rocket][rocket-chip], [BOOM][boom], [CVA6 (Ariane)][cva6]), accelerators ([Hwacha][hwacha], [Gemmini][gemmini], [NVDLA][nvdla]), memory systems, and additional peripherals and tooling to help create a full featured SoC.
Chipyard supports multiple concurrent flows of agile hardware development, including software RTL simulation, FPGA-accelerated simulation ([FireSim][firesim]), automated VLSI flows ([Hammer][hammer]), and software workload generation for bare-metal and Linux-based systems ([FireMarshal][firemarshal]).
Chipyard is actively developed in the [Berkeley Architecture Research Group][ucb-bar] in the [Electrical Engineering and Computer Sciences Department][eecs] at the [University of California, Berkeley][berkeley].

## Resources

* Chipyard Documentation: https://chipyard.readthedocs.io/
* Chipyard Basics slides: https://fires.im/micro19-slides-pdf/02_chipyard_basics.pdf
* Chipyard Tutorial Exercise slides: https://fires.im/micro19-slides-pdf/03_building_custom_socs.pdf

## Need help?

* Join the Chipyard Mailing List: https://groups.google.com/forum/#!forum/chipyard
* If you find a bug, post an issue on this repo

## Contributing

* See [CONTRIBUTING.md](/CONTRIBUTING.md)

## Attribution and Chipyard-related Publications

If used for research, please cite Chipyard by the following publication:

```
@article{chipyard,
  author={Amid, Alon and Biancolin, David and Gonzalez, Abraham and Grubb, Daniel and Karandikar, Sagar and Liew, Harrison and Magyar,   Albert and Mao, Howard and Ou, Albert and Pemberton, Nathan and Rigge, Paul and Schmidt, Colin and Wright, John and Zhao, Jerry and Shao, Yakun Sophia and Asanovi\'{c}, Krste and Nikoli\'{c}, Borivoje},
  journal={IEEE Micro},
  title={Chipyard: Integrated Design, Simulation, and Implementation Framework for Custom SoCs},
  year={2020},
  volume={40},
  number={4},
  pages={10-21},
  doi={10.1109/MM.2020.2996616},
  ISSN={1937-4143},
}
```

* **Chipyard**
    * A. Amid, et al. *IEEE Micro'20* [PDF](https://ieeexplore.ieee.org/document/9099108).
    * A. Amid, et al. *DAC'20* [PDF](https://ieeexplore.ieee.org/document/9218756).
    * A. Amid, et al. *ISCAS'21* [PDF](https://ieeexplore.ieee.org/abstract/document/9401515).

These additional publications cover many of the internal components used in Chipyard. However, for the most up-to-date details, users should refer to the Chipyard docs.

* **Generators**
    * **Rocket Chip**: K. Asanovic, et al., *UCB EECS TR*. [PDF](http://www2.eecs.berkeley.edu/Pubs/TechRpts/2016/EECS-2016-17.pdf).
    * **BOOM**: C. Celio, et al., *Hot Chips 30*. [PDF](https://www.hotchips.org/hc30/1conf/1.03_Berkeley_BROOM_HC30.Berkeley.Celio.v02.pdf).
      * **SonicBOOM (BOOMv3)**: J. Zhao, et al., *CARRV'20*. [PDF](https://carrv.github.io/2020/papers/CARRV2020_paper_15_Zhao.pdf).
      * **COBRA (BOOM Branch Prediction)**: J. Zhao, et al., *ISPASS'21*. [PDF](https://ieeexplore.ieee.org/document/9408173).
    * **Hwacha**: Y. Lee, et al., *ESSCIRC'14*. [PDF](http://hwacha.org/papers/riscv-esscirc2014.pdf).
    * **Gemmini**: H. Genc, et al., *arXiv*. [PDF](https://arxiv.org/pdf/1911.09925).
* **Sims**
    * **FireSim**: S. Karandikar, et al., *ISCA'18*. [PDF](https://sagark.org/assets/pubs/firesim-isca2018.pdf).
        * **FireSim Micro Top Picks**: S. Karandikar, et al., *IEEE Micro, Top Picks 2018*. [PDF](https://sagark.org/assets/pubs/firesim-micro-top-picks2018.pdf).
        * **FASED**: D. Biancolin, et al., *FPGA'19*. [PDF](https://people.eecs.berkeley.edu/~biancolin/papers/fased-fpga19.pdf).
        * **Golden Gate**: A. Magyar, et al., *ICCAD'19*. [PDF](https://davidbiancolin.github.io/papers/goldengate-iccad19.pdf).
        * **FirePerf**: S. Karandikar, et al., *ASPLOS'20*. [PDF](https://sagark.org/assets/pubs/fireperf-asplos2020.pdf).
* **Tools**
    * **Chisel**: J. Bachrach, et al., *DAC'12*. [PDF](https://people.eecs.berkeley.edu/~krste/papers/chisel-dac2012.pdf).
    * **FIRRTL**: A. Izraelevitz, et al., *ICCAD'17*. [PDF](https://ieeexplore.ieee.org/document/8203780).
    * **Chisel DSP**: A. Wang, et al., *DAC'18*. [PDF](https://ieeexplore.ieee.org/document/8465790).
    * **FireMarshal**: N. Pemberton, et al., *ISPASS'21*. [PDF](https://ieeexplore.ieee.org/document/9408192).
* **VLSI**
    * **Hammer**: E. Wang, et al., *ISQED'20*. [PDF](https://www.isqed.org/English/Archives/2020/Technical_Sessions/113.html).



[hwacha]:https://www2.eecs.berkeley.edu/Pubs/TechRpts/2015/EECS-2015-262.pdf
[hammer]:https://github.com/ucb-bar/hammer
[firesim]:https://fires.im
[ucb-bar]: http://bar.eecs.berkeley.edu
[eecs]: https://eecs.berkeley.edu
[berkeley]: https://berkeley.edu
[riscv]: https://riscv.org/
[rocket-chip]: https://github.com/freechipsproject/rocket-chip
[boom]: https://github.com/riscv-boom/riscv-boom
[firemarshal]: https://github.com/firesim/FireMarshal/
[cva6]: https://github.com/openhwgroup/cva6/
[gemmini]: https://github.com/ucb-bar/gemmini
[nvdla]: http://nvdla.org/

# dockerCHIP-seq

### 说明

dockerChip-seq是一个用bash脚本编写的一种用于研究蛋白质与DNA之间的相互作用的工具。它可以帮助识别和定量感兴趣的蛋白质与基因组上特定DNA序列的相互作用。该工具的主要功能是对测序数据进行质量修剪、比对到参考基因组、Peak calling（寻找高信号区域）等。

### 构建Docker 镜像

要将其用于您的 CHIP-seq 分析，请按照以下步骤操作：

1. 确保系统上安装了 Docker。

2. 构建 Docker 镜像：

   ```bash
   docker build -f mydockerfile-centos -t mycentos:0.1 .
   ```

------

### Chip-seq的使用方法

在命令行输入：

```bash
./run.sh <work_path> <file:accession list included>
```

#### 示例

下面是针对给定输入数据进行Chip-seq的示例：

输入：

```bash
./run.sh <work_path> <file_path:accession number(s) to be analyzed>
```

可以实现在当前目录用Chip-seq处理序列，其中文件格式为每行一条序列号

#### 样例文件

```bash
vim SRR_Acc_List.txt
```

```
#样例文件输入：
SRR620204
SRR620205
SRR620206
SRR620207
SRR620208
SRR620209
```

#### 说明：

`align`使用的参考基因组为mm10，如需更换`pre-built reference genome`，可更改workflow.sh中的以下代码：

```bash
mkdir $wkd/align # for storing alignment results
mkdir $wkd/ref # for storing data of the reference mm10 genome
cd $wkd/ref
mkdir mouse
cd mouse
wget -c "ftp://ftp.ccb.jhu.edu/pub/data/bowtie2_indexes/mm10.zip" # download pre-built reference genome to ref
unzip mm10.zip.0
```

如需采用`bowtie2-build`构建索引，可使用：

```bash
nohup bowtie2-build <reference genome path> <basename> &
```

------

### 输出报告

结果将会生成align_result.txt、config、multiqc_report.html、trimming_report、summits.bed、peaks.xls文件。

```
· align_result.txt：包含Chip-seq数据的比对结果。它记录了每个reads或序列如何与参考基因组对齐，并提供了一些相关的统计信息，比如比对质量和覆盖率等。

· config：包含rawdata文件夹下的fastq.gz文件信息。

· multiqc_report.html：包含各种质控指标、统计图表和数据摘要，可以帮助快速了解Chip-seq数据的质量和特征。

· trimming_report：可知经处理read质量变化，以及adapter是否被去除，并得知过滤率。

· summits.bed：记录每个peak的peak summits，即记录极值点的位置，可用该文件寻找结合位点的motif。

· peaks.xls：存放了peak坐标信息。
```

结果同时会生成rawdata、align、multiqc_data、cleandata、reference五个文件夹。

```
· rawdata：该文件夹存储了原始的Chip-seq测序数据及质量报告。

· align：该文件夹包含了Chip-seq的比对结果。这些文件存储了每个reads或序列如何与参考基因组对齐的详细信息。

· multiqc_data：该文件夹含了用于MultiQC生成报告所需的数据这些数据包括质量控制指标、统计数据、图表摘要等信息。

· cleandata：该文件夹包含质控信息，过滤低质量reads以及去接头。

· reference：参考基因组及其索引。
```

------

### 关于反馈和贡献

如果您使用Chip-seq时遇到问题，或者想要为该项目做出改进、提供反馈和建议，请随时与我们联系，我们将不断完善该项目，并得到更好的发展。我们的联系方式：monmon1006@sjtu.edu.cn。
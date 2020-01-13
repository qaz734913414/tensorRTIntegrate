

#include "WReLU.hpp"

typedef TRTInfer::halfloat halfloat;

template<typename _T>
__global__ void relu(_T* input, _T* output, int edge);

template<>
__global__ void relu(float* input, float* output, int edge) {

	KERNEL_POSITION;
	output[position] = (input[position] < 0 ? 0 : input[position]) + 1.3f;
}

template<>
__global__ void relu(halfloat* input, halfloat* output, int edge) {

	KERNEL_POSITION;

	halfloat zero = 0.0f;
	halfloat add = 1.3f;
	output[position] = (input[position] < zero ? zero : input[position]) + add;
}

nvinfer1::Dims WReLU::outputDims(int index, const nvinfer1::Dims* inputDims, int nbInputDims) {
	return inputDims[0];
}

std::shared_ptr<LayerConfig> WReLU::config(const std::string& layerName) {
	auto cfg = TRTPlugin::config(layerName);

	//��������������֧��half��float��ʽ
	cfg->supportDataType_ = {nvinfer1::DataType::kHALF, nvinfer1::DataType::kFLOAT};
	//cfg->supportDataType_ = {nvinfer1::DataType::kHALF};
	return cfg;
}

int WReLU::enqueue(const std::vector<Plugin::GTensor>& inputs, std::vector<Plugin::GTensor>& outputs, const std::vector<GTensor>& weights, void* workspace, cudaStream_t stream) {

	int count = inputs[0].count();
	auto grid = gridDims(count);
	auto block = blockDims(count);

	if (config_->configDataType_ == TRTInfer::DataType::dtFloat) {
		relu <<<grid, block >>> (inputs[0].ptr<float>(), outputs[0].ptr<float>(), count);
	}

	//����������half������£�����half�ķ�����Ч�ʻ�Ƚϸߣ�����half2�����ת��Ϊhalf2�����и��ߵļ���
	else if (config_->configDataType_ == TRTInfer::DataType::dtHalfloat) {
		relu <<<grid, block>>> (inputs[0].ptr<halfloat>(), outputs[0].ptr<halfloat>(), count);
	}
	return 0;
}

RegisterPlugin(WReLU);
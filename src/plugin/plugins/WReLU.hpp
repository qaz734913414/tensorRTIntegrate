
#ifndef WReLU_HPP
#define WReLU_HPP

#include <plugin/plugin.hpp>

using namespace Plugin;

class WReLU : public TRTPlugin {
public:
	//���ò��������ͨ���ִ꣬�в������������ͬʱִ��ģʽƥ�����֣�������ÿ�����������ģʽƥ��
	//��ƥ�䷽���õ���ccutil::patternMatch��������������
	SETUP_PLUGIN(WReLU, "WReLU*");

	virtual std::shared_ptr<LayerConfig> config(const std::string& layerName) override;

	//������ֻ��һ������������shape��������0��shape����˷���input0��shape
	virtual nvinfer1::Dims outputDims(int index, const nvinfer1::Dims* inputDims, int nbInputDims) override;

	//ִ�й���
	int enqueue(const std::vector<GTensor>& inputs, std::vector<GTensor>& outputs, const std::vector<GTensor>& weights, void* workspace, cudaStream_t stream) override;
};

#endif //WReLU_HPP
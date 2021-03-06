set -e

export DOCKER_HOST=ssh://shared_account@10.3.54.102
DOCKER_BUILDKIT=1 docker build --progress=plain -t test_image .

docker run \
          --runtime=nvidia \
          -e NVIDIA_VISIBLE_DEVICES=0 \
          -v svhn:/svhn-data \
          --rm \
          --cpus=5 \
          -t \
          test_image bash -c "python confidnet/train.py -c confidnet/confs/exp_svhn_integration_tests.yaml && \\
                              python confidnet/test.py -c /output_dir/config_1.yaml -e 1"

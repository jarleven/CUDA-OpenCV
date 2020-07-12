from tensorflow.compiler.tf2tensorrt.wrap_py_utils import get_linked_tensorrt_version
from tensorflow.compiler.tf2tensorrt.wrap_py_utils import get_loaded_tensorrt_version

print(f"Linked TensorRT version {get_linked_tensorrt_version()}")
print(f"Loaded TensorRT version {get_loaded_tensorrt_version()}")


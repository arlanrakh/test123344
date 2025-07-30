import 'dart:io';
import 'package:cactus/cactus.dart';

void main() async {
  print('🚀 Cactus Translation Test');
  print('Loading model from local file...\n');
  
  try {
    // Check if local model exists
    final modelPath = '${Directory.current.path}/models/qwen3-600m.gguf';
    final modelFile = File(modelPath);
    
    if (!modelFile.existsSync()) {
      print('❌ Model not found at: $modelPath');
      print('Please run ./download_model.sh first');
      exit(1);
    }
    
    print('✅ Found model at: $modelPath');
    print('📦 Model size: ${(modelFile.lengthSync() / 1024 / 1024).toStringAsFixed(2)} MB\n');
    
    // Initialize Cactus with local model
    print('Initializing Cactus...');
    final lm = await CactusLM.init(
      modelUrl: 'file://$modelPath',
      contextSize: 2048,
      gpuLayers: 0,  // CPU only for compatibility
      threads: 4,
      onProgress: (progress, status, isError) {
        if (!isError) {
          stdout.write('\rLoading: $progress% - $status');
        }
      },
    );
    
    print('\n✅ Model loaded successfully!\n');
    
    // Translation examples
    final translations = [
      {'from': 'Russian', 'to': 'English', 'text': 'Привет, как дела?'},
      {'from': 'English', 'to': 'Russian', 'text': 'Hello, how are you?'},
      {'from': 'Russian', 'to': 'English', 'text': 'Спасибо за помощь'},
      {'from': 'English', 'to': 'Russian', 'text': 'Thank you for your help'},
    ];
    
    for (var item in translations) {
      print('📝 Translating from ${item['from']} to ${item['to']}:');
      print('   Input: ${item['text']}');
      
      final systemPrompt = ChatMessage(
        role: 'system',
        content: 'You are a professional translator. Translate text accurately from ${item['from']} to ${item['to']}. Only provide the translation without any explanations or additional text.',
      );
      
      final userPrompt = ChatMessage(
        role: 'user',
        content: 'Translate: ${item['text']}',
      );
      
      stdout.write('   Output: ');
      
      final result = await lm.completion(
        [systemPrompt, userPrompt],
        maxTokens: 100,
        temperature: 0.3,
        onToken: (token) {
          stdout.write(token);
          return true;
        },
      );
      
      print('\n');
    }
    
    print('✅ Translation test completed!');
    
  } catch (e) {
    print('❌ Error: $e');
    exit(1);
  }
}
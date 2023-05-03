import * as BABYLON from 'babylonjs';
import { useEffect } from 'react';

const MyBabylonScene = () => {
  useEffect(() => {
    const canvas = document.getElementById(
      'babylon-canvas',
    ) as HTMLCanvasElement;

    const engine = new BABYLON.Engine(canvas, true);

    const scene = new BABYLON.Scene(engine);

    const assetManager = new BABYLON.AssetsManager(scene);

    // const myTextureTask = assetManager.addTextureTask(
    //   "myTextureTask",
    //   "path/to/texture.png"
    // );

    // The first parameter can be set to null to load all meshes and skeletons
    BABYLON.SceneLoader.ImportMesh(
      '',
      'https://playground.babylonjs.com/scenes/BoomBox/',
      'BoomBox.gltf',
      scene,
      (newMeshes: any) => {
        newMeshes[0].position.y = 1;
        newMeshes[0].scaling = new BABYLON.Vector3(80, 80, 80);
      },
    );

    scene.render();
    const createScene = async function () {
      const myModel = await BABYLON.SceneLoader.ImportMesh(
        'myModel',
        'https://assets.babylonjs.com/meshes/',
        'HVGirl.glb',
        scene,
      );

      // 모델 로드가 완료된 후, AssetManager에게 모델을 등록합니다.
      // assetManager.addMeshTask('sparrow task', 'sparrow', '/', 'sparrow.glb');

      // 모든 태스크가 로드되었는지 확인합니다.
      assetManager.load();
    };
    createScene();
    // Create Babylon.js scene here...
  }, []);

  return <canvas id="babylon-canvas" />;
};

export default MyBabylonScene;

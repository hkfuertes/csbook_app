import 'package:flutter/material.dart';

class Constants {
  static final String lorem = '''
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Blandit volutpat maecenas volutpat blandit aliquam. Cursus turpis massa tincidunt dui ut ornare lectus sit amet. Viverra nam libero justo laoreet sit amet. Vulputate odio ut enim blandit volutpat maecenas. Consequat mauris nunc congue nisi vitae. Nunc eget lorem dolor sed. Orci nulla pellentesque dignissim enim sit amet. Sit amet facilisis magna etiam tempor. At tempor commodo ullamcorper a lacus. Eget lorem dolor sed viverra ipsum nunc aliquet bibendum. At risus viverra adipiscing at in tellus integer feugiat scelerisque. Nibh venenatis cras sed felis eget velit aliquet sagittis id. Adipiscing tristique risus nec feugiat in fermentum posuere. Fringilla phasellus faucibus scelerisque eleifend donec pretium vulputate. Risus pretium quam vulputate dignissim suspendisse in est ante. Tortor condimentum lacinia quis vel. Sit amet consectetur adipiscing elit duis tristique sollicitudin nibh sit.

Tortor dignissim convallis aenean et tortor. Cras sed felis eget velit aliquet sagittis id consectetur. Tincidunt praesent semper feugiat nibh sed pulvinar. Risus commodo viverra maecenas accumsan lacus vel. Tellus rutrum tellus pellentesque eu. Elementum integer enim neque volutpat ac tincidunt vitae. Semper viverra nam libero justo laoreet. In hac habitasse platea dictumst quisque sagittis purus sit amet. Quam nulla porttitor massa id neque aliquam vestibulum morbi. Elit pellentesque habitant morbi tristique senectus et netus et malesuada.

Pellentesque pulvinar pellentesque habitant morbi tristique senectus et. Et malesuada fames ac turpis egestas sed tempus urna et. A erat nam at lectus urna duis convallis convallis tellus. Amet aliquam id diam maecenas. Mauris sit amet massa vitae tortor condimentum. Consequat id porta nibh venenatis cras sed felis eget velit. Turpis egestas integer eget aliquet nibh. Eget felis eget nunc lobortis mattis aliquam faucibus. Fermentum et sollicitudin ac orci phasellus. Ut faucibus pulvinar elementum integer enim neque. Ultrices neque ornare aenean euismod elementum nisi quis. Eu nisl nunc mi ipsum faucibus vitae aliquet. Hac habitasse platea dictumst quisque sagittis purus sit amet. Amet nisl purus in mollis. Iaculis nunc sed augue lacus viverra vitae congue eu. Tortor pretium viverra suspendisse potenti. Non arcu risus quis varius quam quisque id diam. Non nisi est sit amet facilisis magna etiam.

Massa tincidunt nunc pulvinar sapien et. Eu scelerisque felis imperdiet proin fermentum leo vel orci. Quisque egestas diam in arcu cursus euismod quis viverra nibh. Tortor dignissim convallis aenean et tortor. Tortor posuere ac ut consequat semper. In aliquam sem fringilla ut morbi tincidunt augue interdum velit. Aliquam sem fringilla ut morbi tincidunt augue interdum. Amet nisl suscipit adipiscing bibendum est. Lobortis feugiat vivamus at augue eget arcu. Lobortis feugiat vivamus at augue eget. Enim facilisis gravida neque convallis a cras semper auctor neque. Ligula ullamcorper malesuada proin libero nunc consequat interdum varius sit. Sem fringilla ut morbi tincidunt augue. Tristique nulla aliquet enim tortor.

Purus non enim praesent elementum facilisis leo. Nulla facilisi cras fermentum odio eu feugiat pretium. Diam maecenas sed enim ut sem viverra. Magnis dis parturient montes nascetur ridiculus. Nisl nisi scelerisque eu ultrices vitae auctor eu augue. Quam vulputate dignissim suspendisse in est ante in nibh mauris. Tincidunt vitae semper quis lectus nulla at. Orci nulla pellentesque dignissim enim sit amet venenatis urna. Aliquet risus feugiat in ante metus dictum at tempor commodo. Mi ipsum faucibus vitae aliquet nec. Urna cursus eget nunc scelerisque viverra mauris. Ante metus dictum at tempor commodo ullamcorper a. Egestas purus viverra accumsan in nisl. Id nibh tortor id aliquet lectus proin. Tortor dignissim convallis aenean et tortor at risus viverra. Vulputate ut pharetra sit amet aliquam.
''';

  static var baseUrl = "http://localhost/api/v1";
  static var baseOldUrl = "https://parroquias.csbook.es/api/v1";

  static List<Widget> makeDummySongs(quantity, cb) {
    return List.generate(quantity, (index) {
      var title = "Song Title $index";
      var author = "Song Author $index";
      return ListTile(
          title: Text(title),
          subtitle: Text(author),
          //trailing: Opacity(opacity: 0.5, child: Icon(Icons.arrow_forward_ios)),
          onTap: () {
            cb(index);
          });
    });
  }
}

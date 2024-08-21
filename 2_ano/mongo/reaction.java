import java.util.HashMap;
import java.util.Map;

public class Reaction {
    int id
    int commentId;
    int perfilId;
    int postId;
    String reaction;


    public Map<String, Object> generateObject(int id, int commentId, int perfilId, String reaction, int postId) {
        if (reaction != null && (postId > 0 or commentId >0)) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("commentId", commentId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("reaction", reaction);
            dicionario.put("postId", postId);
            return dicionario;
        }
        return null;
    }
}

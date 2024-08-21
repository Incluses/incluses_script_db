import java.util.HashMap;
import java.util.Map;

public class Comment {
    int id;
    int postId
    int perfilId
    String comment
    boolean like

    public Map<String, Object> generateObject(int postId, int id, int perfilId, String comment, boolean like) {
        if (perfilId > 0 && comment != null) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("postId", postId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("comment", comment);
            dicionario.put("like", like);
            return dicionario;
        }
        return null;
    }

}



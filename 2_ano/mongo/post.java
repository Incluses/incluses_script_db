import java.util.HashMap;
import java.util.Map;

public class Post {
    int id;
    int attachmentId;
    int perfilId;
    String title;
    String label;

    public Map<String, Object> generateObject(int id, int attachmentId, int perfilId, String title, String label) {
        if (perfilId > 0 && title != null) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("attachmentId", attachmentId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("title", title);
            dicionario.put("label", label);
            return dicionario;
        }
        return null;
    }

}

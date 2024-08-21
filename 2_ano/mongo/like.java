import java.util.HashMap;
import java.util.Map;
import java.util.Date;  

public class Like {
    int id;
    int postId
    int perfilId
    new Date data_like
    boolean like

    public Map<String, Object> generateObject(int postId, int id, int perfilId, Date data_like, boolean like) {
        if (perfilId > 0 && postId > 0) {
             Map<String, Object> dicionario = new HashMap<>();
            dicionario.put("id", id);
            dicionario.put("postId", postId);
            dicionario.put("perfilId", perfilId);
            dicionario.put("data_like", data_like);
            dicionario.put("like", like);
            return dicionario;
        }
        return null;
    }

}



import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.analysis.pl.PolishAnalyzer;

import java.io.IOException;

public class Main {

    public static final String INDEX_DIRECTORY = "F:\\Java\\AdvacedDataProcessing\\lab12\\indecies";

    String[] queries = {
            "dummy",
            "and",
            "urodzić",
            "rodzić",
            "ro*",
            "ponieważ",
            "Lucyna AND akcja",
            "NOT Lucyna AND akcja",
            "\"Naturalnie morderca\"~0",
            "naturanle~0.5"
    };

    public static void main(String[] args) throws IOException, ParseException {
        PolishAnalyzer analyzer = new PolishAnalyzer();
        Index.createIndex(analyzer);


//        w.addDocument(buildDoc("Lucene in Action", "9781473671911"));
//        w.addDocument(buildDoc("Lucene for Dummies", "9780735219090"));
//        w.addDocument(buildDoc("Managing Gigabytes", "9781982131739"));
//        w.addDocument(buildDoc("The Art of Computer Science", "9781250301695"));
//        w.addDocument(buildDoc("Dummy and yummy title", "9780525656161"));



        String querystr = "naturanle~0.5";
        Search.search(querystr, analyzer);

    }



}

import React, { useEffect, useState } from "react";

const API_URL = "https://your-api-gateway-url.amazonaws.com/results";

const AnalysisResults = ({ userId }) => {
  const [results, setResults] = useState([]);

  useEffect(() => {
    fetch(`${API_URL}?user_id=${userId}`)
      .then((response) => response.json())
      .then((data) => setResults(data))
      .catch((error) => console.error("Error fetching results:", error));
  }, [userId]);

  return (
    <div>
      <h2>Analysis Results</h2>
      <ul>
        {results.map((result) => (
          <li key={result.document_id}>
            <strong>{result.document_name}</strong>
            <p>{JSON.stringify(result.analysis_result, null, 2)}</p>
          </li>
        ))}
      </ul>
    </div>
  );
};

export default AnalysisResults;
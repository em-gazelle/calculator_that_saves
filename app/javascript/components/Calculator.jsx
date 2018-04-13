import React from "react"
import PropTypes from "prop-types"

class Calculator extends React.Component {
  
  constructor(props) {
    super(props);
    this.state = { 
    	newCalculationQuery: '',
		calculations: []
	};

    this.handleQueryChange = this.handleQueryChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleButtonQueryChanges = this.handleButtonQueryChanges.bind(this);
    this.deleteCharacter = this.deleteCharacter.bind(this);
  	this.clearQueryForm = this.clearQueryForm.bind(this);
  }

  componentDidMount() {
    $.ajax({
		url: '/api/calculations',
		method: 'GET',
		success: function(data) {
  			this.setState({ calculations: data.calculations });
		}.bind(this),
		error: function(xhr, status, error) {
			alert('Calculations could not be retrieved', error);
		}
    });
  }


  handleSubmit(event) {
    $.ajax({
		url: '/api/calculations',
		method: 'POST',
		data: { calculation: this.state.newCalculationQuery },
		success: function(data) {
  			this.setState({ calculations: data.calculations });
  			this.setState({newCalculationQuery: ''});
		}.bind(this),
		error: function(xhr, status, error) {
			alert('Calculation could not be made', error);
		}
    });
    event.preventDefault();
  }

  handleQueryChange(event) {
    this.setState({newCalculationQuery: event.target.value});
  }

  handleButtonQueryChanges(event) {
  	this.setState({newCalculationQuery: this.state.newCalculationQuery + event.target.value});
  }

  deleteCharacter(event) {
  	this.setState({newCalculationQuery: this.state.newCalculationQuery.slice(0,-1)});
  }

  clearQueryForm(event) {
    this.setState({newCalculationQuery: ''});
  }


  render () {
	var calculations = this.state.calculations.map(function(calculation, index) {
		return(
		    <li key={index}>
		      {calculation}
		    </li>
		)
	}.bind(this));

    return (
	  <div>
	  	<h3 className="center-text">~Calculate and Save~</h3>

        <div className="calculator">
	        <div>
	        	<input className="calculator-screen" type="text" value={this.state.newCalculationQuery} onChange={this.handleQueryChange} />
	        </div>
	        <div>
		        <button className="small-btn btn-text" value="(" onClick={this.handleButtonQueryChanges} >&#40;</button>
		        <button className="small-btn btn-text" value=")" onClick={this.handleButtonQueryChanges} >&#41;</button>
		        <button className="small-btn btn-text" onClick={this.deleteCharacter} >&larr;</button>
		        <button className="medium-btn btn-text" onClick={this.clearQueryForm} >AC</button>
	        </div>
	        <div>
		        <button className="small-btn btn-text" value="7" onClick={this.handleButtonQueryChanges} >7</button>
		        <button className="small-btn btn-text" value="8" onClick={this.handleButtonQueryChanges} >8</button>
		        <button className="small-btn btn-text" value="9" onClick={this.handleButtonQueryChanges} >9</button>
		        <button className="small-btn btn-text" value="sqrt" onClick={this.handleButtonQueryChanges} >&#8730;</button>
		        <button className="small-btn btn-text" value="^" onClick={this.handleButtonQueryChanges} >x<sup>a</sup></button>
	        </div>
	        <div>
		        <button className="small-btn btn-text" value="4" onClick={this.handleButtonQueryChanges} >4</button>
		        <button className="small-btn btn-text" value="5" onClick={this.handleButtonQueryChanges} >5</button>
		        <button className="small-btn btn-text" value="6" onClick={this.handleButtonQueryChanges} >6</button>
		        <button className="small-btn btn-text" value="*" onClick={this.handleButtonQueryChanges} >&times;</button>
		        <button className="small-btn btn-text" value="/" onClick={this.handleButtonQueryChanges} >&divide;</button>
	        </div>
	        <div>
		        <button className="small-btn btn-text" value="1" onClick={this.handleButtonQueryChanges} >1</button>
		        <button className="small-btn btn-text" value="2" onClick={this.handleButtonQueryChanges} >2</button>
		        <button className="small-btn btn-text" value="3" onClick={this.handleButtonQueryChanges} >3</button>
		        <button className="small-btn btn-text" value="+" onClick={this.handleButtonQueryChanges} >+</button>
		        <button className="small-btn btn-text" value="-" onClick={this.handleButtonQueryChanges} >-</button>
	        </div>
	        <div>
		        <button className="small-btn btn-text" value="0" onClick={this.handleButtonQueryChanges} >0</button>
		        <button className="small-btn btn-text" value="." onClick={this.handleButtonQueryChanges} >.</button>
		        <button className="large-btn btn-text" onClick={this.handleSubmit} >&#65309;</button>
	        </div>
        </div>

        <br/>
        <div className="horizontally-centered">
        	<h4 className="center-text">Prior Calculations:</h4>
        	<ol>{calculations}</ol>
        </div>
      </div>

    );
  }
}

export default Calculator

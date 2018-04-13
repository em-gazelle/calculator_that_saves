import React from "react"
import PropTypes from "prop-types"

// import CalculatorButton from '../common/CalculatorButton'


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
	  	<React.Fragment>Calculate!</React.Fragment>
	  	<div>
		  <form onSubmit={this.handleSubmit}>
	        <label>
	          <input type="text" value={this.state.newCalculationQuery} onChange={this.handleQueryChange} />
	        </label>
	      </form>
        </div>

        <div className="calculator">
	        <div className="calculator-row">
		        <button value="(" onClick={this.handleButtonQueryChanges} >&#40;</button>
		        <button value=")" onClick={this.handleButtonQueryChanges} >&#41;</button>
		        <button onClick={this.deleteCharacter} >&larr;</button>
		        <button onClick={this.clearQueryForm} >~ AC ~</button>
	        </div>
	        <div className="calculator-row">
		        <button value="7" onClick={this.handleButtonQueryChanges} >7</button>
		        <button value="8" onClick={this.handleButtonQueryChanges} >8</button>
		        <button value="9" onClick={this.handleButtonQueryChanges} >9</button>
		        <button value="sqrt" onClick={this.handleButtonQueryChanges} >&#8730;</button>
		        <button value="^" onClick={this.handleButtonQueryChanges} >x<sup>a</sup></button>
	        </div>
	        <div className="calculator-row">
		        <button value="4" onClick={this.handleButtonQueryChanges} >4</button>
		        <button value="5" onClick={this.handleButtonQueryChanges} >5</button>
		        <button value="6" onClick={this.handleButtonQueryChanges} >6</button>
		        <button value="*" onClick={this.handleButtonQueryChanges} >&times;</button>
		        <button value="/" onClick={this.handleButtonQueryChanges} >&divide;</button>
	        </div>
	        <div className="calculator-row">
		        <button value="1" onClick={this.handleButtonQueryChanges} >1</button>
		        <button value="2" onClick={this.handleButtonQueryChanges} >2</button>
		        <button value="3" onClick={this.handleButtonQueryChanges} >3</button>
		        <button value="+" onClick={this.handleButtonQueryChanges} >+</button>
		        <button value="-" onClick={this.handleButtonQueryChanges} >-</button>
	        </div>
	        <div className="calculator-row">
		        <button value="0" onClick={this.handleButtonQueryChanges} >0</button>
		        <button value="." onClick={this.handleButtonQueryChanges} >.</button>
		        <button onClick={this.handleSubmit} > &#61;&#61;&#61;&#61;&#61;&#61;&#61; </button>
	        </div>
        </div>

        <br/>
        <div>
        	Prior Calculations: 

        	<ol>
        		{calculations}
        	</ol>
        </div>
      </div>

    );
  }
}

export default Calculator
